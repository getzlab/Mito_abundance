#Ratio of mito depth to autosome depth
import pandas as pd
import argparse

parser = argparse.ArgumentParser(description='Process some integers.')
parser.add_argument('--coverage', nargs=1, help='File path for coverage file.')
parser.add_argument('--ploidy', type=float, nargs=1, help='Ploidy data')
args = parser.parse_args() 

# --coverage ./coverage_test.tsv  --ploidy 2 

file_name = args.coverage[0]
ploidy = args.ploidy[0]

coverage_data = pd.read_csv(file_name, sep='\t')
coverage_data.set_index("#rname", inplace=True)

autosome_total_depth = 0
autosome_size = 0
for i in range(1,23):
    #print("chr%s"%(i) )
    chrom = "chr%s"%(i) 
    if chrom in coverage_data.index:
        chrom_size = coverage_data.loc[chrom, "endpos"] - coverage_data.loc[chrom, "startpos"]
        autosome_total_depth = autosome_total_depth + coverage_data.loc[chrom,  "meandepth"] * chrom_size
        autosome_size = autosome_size + chrom_size

mean_mito_depth = coverage_data.loc["chrM", "meandepth"]
mean_haploid_depth = autosome_total_depth / autosome_size
mean_corrected_auto_depth = mean_haploid_depth / ploidy
mito_ratio = mean_mito_depth / mean_corrected_auto_depth

#print("mean mitochondria read depth  = %s"%(mean_mito_depth)) 
#print("mean_haploid_depth is %s"%(mean_haploid_depth))
#print("mean_corrected_auto_depth is %s"%(mean_corrected_auto_depth))
#print("Mitocondria Fraction is %s"%(mito_ratio))

# calculate
output_file1 = "mean_haploid_depth.txt"
with open(output_file1, 'w') as fh:
    fh.write("%s"%(mean_haploid_depth))

output_file2 = "mean_corrected_auto_depth.txt"
with open(output_file2, 'w') as fh:
    fh.write("%s"%(mean_corrected_auto_depth))

output_file3 = "mito_ratio.txt"
with open(output_file3, 'w') as fh:
    fh.write("%s"%(mito_ratio))

output_file4 = "mean_mito_depth.txt"
with open(output_file4, 'w') as fh:
    fh.write("%s"%(mean_mito_depth))


    