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

cp /data/GL/database/AnnotSV_annotations/Annotations_Human/Gene-based/OMIM/*_morbid.tsv.gz /data/GL/database/AnnotSV_annotations/Annotations_Human/FtIncludedInSV/PathogenicSV/GRCh37/
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

cp /data/GL/database/AnnotSV_annotations/Annotations_Human/Gene-based/OMIM/*_morbid.tsv.gz /data/GL/database/AnnotSV_annotations/Annotations_Human/FtIncludedInSV/PathogenicSV/GRCh38/

```

### Update Haploinsufficiency (HI) and triplosensitivity (TS) scores annotations

### Build
```bash
docker build -t namxle/ubuntu-annotsv:22.04-3.4 .

docker run -v ./:/workspace -it namxle/ubuntu-annotsv:22.04-3.4 /bin/bash run.sh 

docker run -v ./:/workspace -v /data/GL/database/:/database -it namxle/ubuntu-annotsv:22.04-3.4 bash

cd AnnotSV_annotations
git clone https://github.com/lgmgeo/AnnotSV.git
cd AnnotSV
make PREFIX=. install
make PREFIX=. install-human-annotation
mv share/AnnotSV/Annotations_Exomiser ..
mv share/AnnotSV/Annotations_Human ..
cd ..
rm -r AnnotSV

 git submodule foreach git pull
 git submodule update --init --recursive --remote
 git pull --recurse-submodules

```
### Run
```bash
docker run -v ./:/workspace -v /data/GL/database/:/database -it namxle/ubuntu-annotsv:22.04-3.4 bash

/workspace/AnnotSV/bin/AnnotSV \
-annotationsDir /database/AnnotSV_annotations \
-genomeBuild GRCh37 \
-outputDir /workspace/output \
-outputFile result.tsv \
-SVinputFile CNV.vcf \
-annotationMode full \
-SVminSize 10
```