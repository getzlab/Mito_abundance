task get_bam_idxstats {

    File bam_file
    File bai_file
    String sample_id
    File coverage_script 
    Int memory_gb
    Int disk_size

    command {
        set -euo pipefail
        echo $(date +"[%b %d %H:%M:%S] samtools: getting coverage over chrM")
        cp ${bai_file} .
       
        samtools coverage ${bam_file} > ${sample_id}_read_statistics_noH.tsv
        python3 ${coverage_script} --coverage ${sample_id}_read_statistics_noH.tsv --purity #### 

        echo $(date +"[%b %d %H:%M:%S] done.")
    }

    output {
        File mito_percent = sample_id + "_mito_statistics.idxstats"
        Float mean_haploid_depth = read_float("mean_haploid_depth.txt")
        Float mean_corrected_auto_depth = read_float("mean_corrected_auto_depth.txt")
        Float mito_ratio = read_float("mito_ratio.txt")
        File ref_seq_read_mapping = sample_id + "_read_statistics.idxstats"
    }

    runtime {
    	docker: "broadinstitute/genomes-in-the-cloud:2.3.1-1500064817"
        memory: memory_gb + "GB"
        disks: "local-disk " + disk_size + " HDD"
    }

    meta {
        author: "Mark Holton"
        email: "mholton@broadinstitute.org"
    }
}

workflow get_bam_idxstats_workflow {
    call get_bam_idxstats
}