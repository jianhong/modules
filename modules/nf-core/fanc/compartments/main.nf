process FANC_COMPARTMENTS {
    tag "$meta.id"
    label 'process_medium'
    label 'process_single'

    conda (params.enable_conda ? "bioconda::fanc=0.9.23b" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/fanc:0.9.23b--py37h8902056_2':
        'quay.io/biocontainers/fanc:0.9.23b--py37h8902056_2' }"

    input:
    tuple val(meta), path(matrix)
    val resolution

    output:
    tuple val(meta), path("${prefix}*"), emit: compartments
    path "versions.yml"                , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    prefix = task.ext.prefix ?: "${meta.id}"
    def postfix = resolution? "@$resolution":''
    """
    fanc compartments \\
        $args \\
        $matrix$postfix \\
        ${prefix}.ab

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        fanc: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//' ))
    END_VERSIONS
    """
}
