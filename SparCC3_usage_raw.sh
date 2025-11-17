## reference: SparCC3 document
## link: https://github.com/JCSzamosi/SparCC3
wkdir=$1
mtx_fn=$2
sparcc_dir=$3

echo 'the working directory was set as ${wkdir}, output files would be stored here.'
printf '\n'
echo 'the input `.tsv` file was set as ${mtx_fn}, please confirm it exists.'
printf '\n'
echo 'the executable software was set as ${sparcc_dir}, please make sure `SparCC3` related scripts were here'
printf '\n'
printf '\n'
printf '\n'

echo '##### change to the working directory #####'
mkdir -p ${wkdir}
cd ${wkdir}
mkdir -p sparcc/pvals/sparcc

printf '\n'
printf '\n'
printf '\n'

# step1: correlation matrix of the observed values
echo '#### step1 starts ####'
printf '\n'
time python ${sparcc_dir}/SparCC.py ${mtx_fn} -i 20 --cor_file=sparcc/sxtr_sparcc.tsv 
printf '\n'
echo '#### step1 complete ####'

printf '\n'
printf '\n'
printf '\n'

# step2: random sampling with bootstrap method
echo '#### step2 starts ####'
printf '\n'
time python ${sparcc_dir}/MakeBootstraps.py ${mtx_fn} -n 1000 -t sparcc/bootstrap_#.txt -p sparcc/pvals/ 
printf '\n'
echo '#### step2 complete ####'

printf '\n'
printf '\n'
printf '\n'

# step3: pseudo-p.value calculation, for each sampling matrix
echo '#### step3 starts ####'
printf '\n'
time for i in {0..999}; 
do 
  ${sparcc_dir}/SparCC.py \
    sparcc/pvals/sparcc/bootstrap_${i}.txt \
    -i 20 --cor_file=sparcc/pvals/bootstrap_cor_${i}.txt 
done 
printf '\n'
echo '#### step3 complete ####'

printf '\n'
printf '\n'
printf '\n'

# step4: get the pseudo p-values. 
# Remember to make sure all the correlation files are in the same folder, are numbered sequentially, and have a '.txt' extension. 
# The following will compute two sided p-values
echo '#### step4 starts ####'
printf '\n'
time python ${sparcc_dir}/PseudoPvals.py \
  sxtr_sparcc.tsv sparcc/pvals/bootstrap_cor_#.txt 1000 \
  -o pvals/pvals.two_sided.txt -t two_sided 
printf '\n'
echo '#### step4 complete ####'
printf '\n'
mv pvals/pvals.two_sided.txt sxtr_pvals.two_sided.tsv; mv cov_mat_SparCC.out sxtr_cov_mat_SparCC.tsv

echo 'all steps complete, please check your output files, good luck'
