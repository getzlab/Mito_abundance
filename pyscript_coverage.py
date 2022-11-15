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
print(coverage_data.columns[0])
coverage_data.set_index(coverage_data.columns[0], inplace=True)
print(coverage_data.head())

if "chrM" in coverage_data.index:    
    mean_mito_depth = coverage_data.loc["chrM", "meandepth"]
    mito_size = (coverage_data.loc["chrM", "endpos"] - coverage_data.loc["chrM", "startpos"])
    # add warning if mito_size less than 10 thousand

    #total_mito_depth = coverage_data.loc["chrM", "meandepth"] * mito_size 
    total_mito_reads = coverage_data.loc["chrM", "numreads"] 
    #mean_mito_reads = coverage_data.loc["chrM", "numreads"] / mito_size
elif "MT" in coverage_data.index:    
    mean_mito_depth = coverage_data.loc["MT", "meandepth"]
    mito_size = (coverage_data.loc["MT", "endpos"] - coverage_data.loc["MT", "startpos"]) 
    #total_mito_depth = coverage_data.loc["MT", "meandepth"] * mito_size 
    total_mito_reads = coverage_data.loc["MT", "numreads"] / mito_size
else:
    print("Can't find Mitochondria Gene row of coverage file.")
    mean_mito_depth = 0
    mito_size = 0
    #total_mito_depth = 0
    total_mito_reads = 0

autosome_total_depth = 0
autosome_total_reads = 0
autosome_size = 0
for i in range(1,23):
    chrom = "chr%s"%(i) 
    print("chrom = %s"%(chrom))
    #print(str(i) in coverage_data.index)
    if chrom in coverage_data.index:
        chrom_size = coverage_data.loc[chrom, "endpos"] - coverage_data.loc[chrom, "startpos"]
        autosome_size = autosome_size + chrom_size # output
        autosome_total_depth = autosome_total_depth + coverage_data.loc[chrom,  "meandepth"] * chrom_size # not output
        autosome_total_reads = autosome_total_reads + coverage_data.loc[chrom,  "numreads"] # output
    elif str(i) in coverage_data.index:
        chrom_size = coverage_data.loc[str(i), "endpos"] - coverage_data.loc[str(i), "startpos"]
        autosome_size = autosome_size + chrom_size
        autosome_total_depth = autosome_total_depth + coverage_data.loc[str(i),  "meandepth"] * chrom_size 
        autosome_total_reads = autosome_total_reads + coverage_data.loc[chrom,  "numreads"] 



print("autosome size is %s"%(autosome_size))
print("ploidy is %s"%(ploidy))

mean_haploid_depth = autosome_total_depth / autosome_size
#mean_haploid_reads = autosome_total_reads / autosome_size

mean_corrected_auto_depth = mean_haploid_depth / ploidy
#mean_corrected_auto_reads = mean_haploid_reads / ploidy

mito_ratio = mean_mito_depth / mean_corrected_auto_depth

#print("mean mitochondria read depth  = %s"%(mean_mito_depth)) 
#print("mean_haploid_depth is %s"%(mean_haploid_depth))
#print("mean_corrected_auto_depth is %s"%(mean_corrected_auto_depth))
#print("Mitocondria Fraction is %s"%(mito_ratio))

# calculate
with open("mean_mito_depth.txt", 'w') as fh:
    fh.write("%s"%(mean_mito_depth))
with open("mito_ratio.txt", 'w') as fh:
    fh.write("%s"%(mito_ratio))
with open("autosome_size.txt", 'w') as fh:
    fh.write("%s"%(autosome_size))
#with open("total_mito_depth.txt", 'w') as fh:
#    fh.write("%s"%(total_mito_depth))
with open("total_mito_reads.txt", 'w') as fh:
    fh.write("%s"%(total_mito_reads))

with open("autosome_total_depth.txt", 'w') as fh:
    fh.write("%s"%(autosome_total_depth))
with open("autosome_total_reads.txt", 'w') as fh:
    fh.write("%s"%(autosome_total_reads))

with open("mean_haploid_depth.txt", 'w') as fh:
    fh.write("%s"%(mean_haploid_depth))
with open("mean_corrected_auto_depth.txt", 'w') as fh:
    fh.write("%s"%(mean_corrected_auto_depth))


    




