version 1.0

task get_mito_abundance {

    input {
        String sample_id
        String bam_file_path
        String my_project_name 
        File coverage_script         
        Int ploidy 
        String docker_image = "gcr.io/broad-getzlab-workflows/mito_abundance:1" 
        Int memory_gb = 4
        Int disk_size = 50
        
    }

    command {
        echo Start
        
        set -euo pipefail
        
		echo HelloWorld
        
        export GCS_OAUTH_TOKEN=`gcloud auth application-default print-access-token`  && export GCS_REQUESTER_PAYS_PROJECT=${my_project_name} && samtools coverage ${bam_file_path} > ${sample_id}_read_statistics_noH.tsv 
        
        echo python
        
        python3 ${coverage_script} --coverage ${sample_id}_read_statistics_noH.tsv --ploidy ${ploidy}

    }

    output {
        File mito_percent = sample_id + "_mito_statistics.idxstats"
        Float mean_haploid_depth = read_float("mean_haploid_depth.txt")
        Float mean_corrected_auto_depth = read_float("mean_corrected_auto_depth.txt")
        Float mito_ratio = read_float("mito_ratio.txt")
        File ref_seq_read_mapping = sample_id + "_read_statistics.idxstats"
    }

    runtime {
    	docker: docker_image
        memory: memory_gb + "GB"
        disks: "local-disk " + disk_size + " HDD"
    }

    meta {
        author: "Mark Holton"
        email: "mholton@broadinstitute.org"
    }
}

workflow mito_abundance_workflow {

    input {
        String bam_file_path
        String my_project_name 
        String sample_id
        File coverage_script 
        Int ploidy 
        Int memory_gb = 4
        Int disk_size = 50
    }


    call get_mito_abundance {
        input:
            bam_file_path = bam_file_path,
            sample_id = sample_id,
            my_project_name = my_project_name,
            coverage_script = coverage_script,
            ploidy = ploidy,
            memory_gb = memory_gb,
            disk_size = disk_size,
    }   


    output {
        File mito_percent = get_mito_abundance.mito_percent
        Float mean_haploid_depth = get_mito_abundance.mean_haploid_depth
        Float mean_corrected_auto_depth = get_mito_abundance.mean_corrected_auto_depth
        Float mito_ratio = get_mito_abundance.mito_ratio
        File ref_seq_read_mapping = get_mito_abundance.ref_seq_read_mapping
    }
    
}