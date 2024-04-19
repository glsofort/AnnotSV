### Update Known pathogenic genes or genomic regions annotation

#### hg37

```bash
rm /data/GL/database/AnnotSV_annotations/Annotations_Human/FtIncludedInSV/PathogenicSV/GRCh37/*

cd /data/GL/database/AnnotSV_annotations/Annotations_Human/FtIncludedInSV/PathogenicSV/GRCh37

wget https://ftp.ncbi.nlm.nih.gov/pub/clinvar/vcf_GRCh37/clinvar_20240416.vcf.gz
wget ftp://ftp.clinicalgenome.org/ClinGen_gene_curation_list_GRCh37.tsv
wget ftp://ftp.clinicalgenome.org/ClinGen_region_curation_list_GRCh37.tsv

wget https://ftp.ncbi.nlm.nih.gov/pub/dbVar/sandbox/sv_datasets/nonredundant/deletions/GRCh37.nr_deletions.pathogenic.tsv.gz
wget https://ftp.ncbi.nlm.nih.gov/pub/dbVar/sandbox/sv_datasets/nonredundant/duplications/GRCh37.nr_duplications.pathogenic.tsv.gz
wget https://ftp.ncbi.nlm.nih.gov/pub/dbVar/sandbox/sv_datasets/nonredundant/insertions/GRCh37.nr_insertions.pathogenic.tsv.gz

```

#### hg38

```bash
rm /data/GL/database/AnnotSV_annotations/Annotations_Human/FtIncludedInSV/PathogenicSV/GRCh38/*

cd /data/GL/database/AnnotSV_annotations/Annotations_Human/FtIncludedInSV/PathogenicSV/GRCh38

wget https://ftp.ncbi.nlm.nih.gov/pub/clinvar/vcf_GRCh38/clinvar_20240416.vcf.gz
wget ftp://ftp.clinicalgenome.org/ClinGen_gene_curation_list_GRCh38.tsv
wget ftp://ftp.clinicalgenome.org/ClinGen_region_curation_list_GRCh38.tsv

wget https://ftp.ncbi.nlm.nih.gov/pub/dbVar/sandbox/sv_datasets/nonredundant/deletions/GRCh38.nr_deletions.pathogenic.tsv.gz
wget https://ftp.ncbi.nlm.nih.gov/pub/dbVar/sandbox/sv_datasets/nonredundant/duplications/GRCh38.nr_duplications.pathogenic.tsv.gz
wget https://ftp.ncbi.nlm.nih.gov/pub/dbVar/sandbox/sv_datasets/nonredundant/insertions/GRCh38.nr_insertions.pathogenic.tsv.gz

```

### Update Haploinsufficiency (HI) and triplosensitivity (TS) scores annotations

