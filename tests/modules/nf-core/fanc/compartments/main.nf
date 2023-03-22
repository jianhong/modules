#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { FANC_COMPARTMENTS } from '../../../../../modules/nf-core/fanc/compartments/main.nf'

workflow test_fanc_compartments {
    
    input = [
        [ id:'test', single_end:false ], // meta map
        file(params.test_data['sarscov2']['illumina']['test_paired_end_bam'], checkIfExists: true)
    ]

    FANC_COMPARTMENTS ( input )
}
