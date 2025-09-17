#! /usr/bin/bash
project=$1
dataset=$2
species=$3
samp=$4

datdir=/cluster/home/danyang_jh/projects/${project}/data/${dataset}/${species}/rnaseq

input.R1=${datdir}/${samp}_R1.fq.gz
input.R2=${datdir}/${samp}_R2.fq.gz

salmon_outdir=${workdir}/salmon/${samp}
log_dir=${salmon_outdir}/logs
mkdir -p ${salmon_outdir} ${log_dir}

if [[ "$species" == "mouse" ]]; then
    salmon_index="/cluster/home/jhuang/reference/encode/mouse/salmon_index1.10.3"
    salmon_gtf="/cluster/home/jhuang/reference/encode/mouse/annotation/vm36/gencode.vM36.annotation.gtf"
elif [[ "$species" == "human" ]]; then
    salmon_index="/cluster/home/jhuang/reference/encode/human/salmon_index1.10.3"
    salmon_gtf="/cluster/home/jhuang/reference/encode/human/annotation/v47/gencode.v47.annotation.gtf"
else
    echo "Check species!"
fi

time salmon quant \
 -p 8 \
 -i ${salmon_index} \
 -l A \
 --validateMappings \
 -1 ${input.R1} \
 -2 ${input.R2} \
 -g ${salmon_gtf} \
 -o ${salmon_outdir}
