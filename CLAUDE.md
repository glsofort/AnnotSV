# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

AnnotSV is an integrated tool for Structural Variation (SV) annotation and ranking, written primarily in **Tcl**. It annotates SVs from BED or VCF input with dozens of genomic data sources and assigns pathogenicity rankings (ACMG classes 1-5). Supports Human (GRCh37, GRCh38, CHM13) and Mouse (mm9, mm10, mm39) genomes.

## Build & Install

```bash
# Local install (recommended for development)
make PREFIX=. install

# Download annotation databases (required to run)
make PREFIX=. install-human-annotation    # ~1h download
make PREFIX=. install-mouse-annotation

# Install Exomiser phenotype prioritization (optional)
make PREFIX=. install-exomiser
```

**Prerequisites:** tclsh (Tcl 8.5+), bedtools, bcftools, Python 3 (for variantconvert), Java (for Exomiser).

## Running AnnotSV

```bash
export ANNOTSV=/path/to/AnnotSV
$ANNOTSV/bin/AnnotSV -SVinputFile input.vcf -outputFile output.tsv -genomeBuild GRCh38
```

## Tests

Tests are in `tests/AnnotSV/`. Each `test_##_<name>/` directory contains input data and a `command_Tcl.sh` script. Tests validate by checking for "ok - Finished" in output.

```bash
# Run all tests (~1h15m)
cd tests/AnnotSV
bash scripts/check_all_public_test_directory.sh

# Run a single test
cd tests/AnnotSV/test_01_configfile
export ANNOTSV=/path/to/AnnotSV
./command_Tcl.sh
```

Tests require the `$ANNOTSV` environment variable to point to the installation directory, and annotation databases must be installed.

## Architecture

### Entry Point

`bin/AnnotSV` — a Tcl script that sources all modules and orchestrates the pipeline:
1. `configureAnnotSV` — parse CLI args and config
2. `VCFsToBED` — convert VCF input to BED (if needed)
3. `check*` functions — validate annotation data sources exist
4. `genesAnnotation` — annotate genes overlapping SVs
5. `OrganizeAnnotation` — run all annotation modules and write output

### Module Organization

All core logic lives in `share/tcl/AnnotSV/` as ~35 Tcl files, each handling a specific annotation source:

| Module pattern | Purpose |
|---|---|
| `AnnotSV-config.tcl` | CLI/config parsing, sets `g_AnnotSV()` array |
| `AnnotSV-vcf.tcl` | VCF parsing, multiallelic handling |
| `AnnotSV-genes.tcl` | Gene overlap detection (RefSeq/ENSEMBL) |
| `AnnotSV-benignsv.tcl` | Benign SV databases (DGV, gnomAD-SV) |
| `AnnotSV-pathogenicsv.tcl` | Pathogenic SV databases (ClinVar, dbVar) |
| `AnnotSV-ranking.tcl` | ACMG-based SV ranking algorithm |
| `AnnotSV-write.tcl` | Output generation, coordinate conversion |
| `AnnotSV-extann.tcl` | External/user-provided annotations |
| `AnnotSV-exomiser.tcl` | Exomiser REST API integration |
| `AnnotSV-regulatoryelements.tcl` | Enhancers, promoters, ABC, GH, MPRA |

Other modules follow the `AnnotSV-<source>.tcl` naming pattern (omim, cosmic, clingen, repeat, segdup, gap, tad, cytoband, etc.).

Bundled Tcl libraries (JSON, CSV, HTTP, TAR) are in `share/tcl/AnnotSV/tcllib/`.

### Key Conventions

- **Global state:** The `g_AnnotSV()` Tcl array holds all configuration and runtime state. Accessed throughout all modules.
- **Column indices:** `g_i()` array maps output column names to positions.
- **Coordinate systems:** BED uses 0-based half-open; VCF uses 1-based. Conversion happens in `AnnotSV-write.tcl`.
- **Annotation data:** Stored under `share/AnnotSV/Annotations_Human/` (or `_Mouse/`), organized as `Gene-based/`, `FtIncludedInSV/`, `BreakpointsAnnotations/`, and `Users/`.
- **Config file:** `etc/AnnotSV/configfile` defines default options and which output columns to include. Users can customize by placing a `configfile` in the same directory as the input file.
- **Each check function** (e.g., `checkBenignFiles`, `checkPathogenicFiles`) validates that annotation data exists and pre-processes it into sorted BED format for bedtools intersection.

### Docker (custom fork)

```bash
docker build -t namxle/ubuntu-annotsv:22.04-3.4 .
docker run -v ./:/workspace -v /data/GL/database/:/database -it namxle/ubuntu-annotsv:22.04-3.4 bash
```
