version 1.0

task get_mito_abundance {

    input {
        String sample_id
        String bam_file_path
        String my_project_name 
        File coverage_script         
        Float ploidy 
        String docker_image = "gcr.io/broad-getzlab-workflows/mito_abundance:2" 
        Int memory_gb = 2
        Int disk_size = 4
        Int num_threads = 4

        
    }
            
    command {
        set -euo pipefail
        
        export GCS_OAUTH_TOKEN=`gcloud auth application-default print-access-token`  && export GCS_REQUESTER_PAYS_PROJECT=${my_project_name} && samtools coverage ${bam_file_path} --input-fmt-option nthreads=${num_threads} > ${sample_id}_coverage_statistics.tsv 
        
                
        python3 ${coverage_script} --coverage ${sample_id}_coverage_statistics.tsv --ploidy ${ploidy}

    }

    output {
        Float mean_haploid_depth = read_float("mean_haploid_depth.txt")
        Float mean_corrected_auto_depth = read_float("mean_corrected_auto_depth.txt")
        Float mito_ratio = read_float("mito_ratio.txt")
        Float mean_mito_depth = read_float("mean_mito_depth.txt")
        File coverage_file = sample_id + "_coverage_statistics.tsv"
    }

    runtime {
    	docker: docker_image
        memory: memory_gb + "GB"
        disks: "local-disk " + disk_size + " HDD"
        cpu: num_threads
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
        Float ploidy 
        Int memory_gb = 2
        Int disk_size = 10
        Int num_threads = 2
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
            num_threads = num_threads,
    }   


    output {
        Float mean_haploid_depth = get_mito_abundance.mean_haploid_depth
        Float mean_corrected_auto_depth = get_mito_abundance.mean_corrected_auto_depth
        Float mito_ratio = get_mito_abundance.mito_ratio
        Float mean_mito_depth = get_mito_abundance.mean_mito_depth
        File coverage_file = get_mito_abundance.coverage_file

    }
    
}