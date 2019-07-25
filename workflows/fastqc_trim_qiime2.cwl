#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
requirements:
  - class: MultipleInputFeatureRequirement
  - class: SubworkflowFeatureRequirement
inputs:
  files:
    type:
      type: array
      items: File
  barcodes:
    type: File
  metadata:
    type: File
  classifier:
    type: File
  demux_barcode_column:
    type: string
    default: BarcodeSequence
  demux_artifact:
    type: string
    default: demux.qza
  demux_details_artifact:
    type: string
    default: demux-details.qza
  demux_visualization:
    type: string
    default: demux.qzv
  dada2_trim_left:
    type: int
    default: 0
  dada2_trunc_len:
    type: int
    default: 120
  dada2_rep_seq:
    type: string
    default: rep-seqs-dada2.qza
  dada2_table:
    type: string
    default: table-dada2.qza
  dada2_stats:
    type: string
    default: stats-dada2.qza
  metadata_stats_visualization:
    type: string
    default: stats-dada2.qzv
  feature_table_summarize_visualization:
    type: string
    default: table.qzv
  feature_table_tabulate_seqs:
    type: string
    default: rep-seqs.qzv
  phylogeny_alignment:
    type: string
    default: aligned-rep-seqs.qza
  phylogeny_masked_alignment:
    type: string
    default: masked-aligned-rep-seqs.qza
  phylogeny_tree:
    type: string
    default: unrooted-tree.qza
  phylogeny_rooted_tree:
    type: string
    default: rooted-tree.qza
  diversity_sampling_depth:
    type: int
    default: 1
  diversity_metrics_dir:
    type: string
    default: core-metrics-results
  rarefaction_max_depth:
    type: int
    default: 100
  rarefaction_visualization:
    type: string
    default: alpha-rarefaction.qzv
  classifier_sklearn:
    type: string
    default: taxonomy.qza
  classifier_sklearn_visualization:
    type: string
    default: taxonomy.qzv
  taxa_barplot_visualization:
    type: string
    default: taxa-bar-plots.qzv
  feature_table_filter_samples:
    type: string
    default: "BodySite='gut'"
  feature_table_filter_samples_artifact:
    type: string
    default: gut-table.qza
  composition_add_pseudocount_artifact:
    type: string
    default: comp-gut-table.qza
  FqcTr_dir_name:
    type: string
    default: fastqc_trim_workflow
  qiim2_input_dir_name:
    type: string
    default: emp-paired-seq
outputs: 
  Fqc_Tr_dir:
    type: Directory
    outputSource: fastqc_trim_galore/fastqc_trim_workflow_dir
  GZ_files_dir:
    type: Directory
    outputSource: fastqc_trim_galore/qiime2_workflow_input_dir
  out_artifact_tools_import:
    type: File
    outputSource: qiime2_workflow/o_artifact_tools_import
  out_demux:
    type: File
    outputSource: qiime2_workflow/o_demux
  out_demux_details:
    type: File
    outputSource: qiime2_workflow/o_demux_details
  out_demux_summarize:
    type: File
    outputSource: qiime2_workflow/o_demux_summarize
  out_dada2_rep_seq:
    type: File
    outputSource: qiime2_workflow/o_dada2_rep_seq
  out_dada2_table:
    type: File
    outputSource: qiime2_workflow/o_dada2_table
  out_dada2_denoising_stats:
    type: File
    outputSource: qiime2_workflow/o_dada2_denoising_stats
  out_metadata_stats_visualization:
    type: File
    outputSource: qiime2_workflow/o_metadata_stats_visualization 
  out_feature-table-summarize:
    type: File
    outputSource: qiime2_workflow/o_feature-table-summarize
  out_feature-table-tabulate-seqs:
    type: File
    outputSource: qiime2_workflow/o_feature-table-tabulate-seqs
  out_phylogeny_alignment:
    type: File
    outputSource: qiime2_workflow/o_phylogeny_alignment
  out_phylogeny_masked_alignment:
    type: File
    outputSource: qiime2_workflow/o_phylogeny_masked_alignment
  out_phylogeny_tree:
    type: File
    outputSource: qiime2_workflow/o_phylogeny_tree
  out_phylogeny_rooted_tree:
    type: File
    outputSource: qiime2_workflow/o_phylogeny_rooted_tree
  out_diversity_metrics_dir:
    type: Directory
    outputSource: qiime2_workflow/o_diversity_metrics_dir
  out_alpha_rarefaction:
    type: File
    outputSource: qiime2_workflow/o_alpha_rarefaction
  out_classifier_sklearn:
    type: File
    outputSource: qiime2_workflow/o_classifier_sklearn
  out_classifier_sklearn_visualization:
    type: File
    outputSource: qiime2_workflow/o_classifier_sklearn_visualization
  out_taxa_barplot_visualization:
    type: File
    outputSource: qiime2_workflow/o_taxa_barplot_visualization
  out_feature_table_filter_samples_artifact:
    type: File
    outputSource: qiime2_workflow/o_feature_table_filter_samples_artifact
  out_composition_table_visualization:
    type: File
    outputSource: qiime2_workflow/o_composition_table_visualization

steps:
  fastqc_trim_galore:
    run: ../workflows/fastqc_trim.cwl
    in:
      files: files
      barcodes: barcodes
    out: [output_Fqc_Tr, output_GZ_files]
  qiime2_workflow:
    run: ../workflows/qiime2_workflow.cwl
    in:
      fastq_dir: fastqc_trim_galore/qiime2_workflow_input_dir
      barcodes: barcodes
      metadata_file: metadata
      classifier: classifier
      diversity_sampling_depth: diversity_sampling_depth
      rarefaction_max_depth: rarefaction_max_depth
    out: [o_artifact_tools_import, o_demux, o_demux_details, o_demux_summarize,
          o_dada2_rep_seq, o_dada2_table, o_dada2_denoising_stats, o_metadata_stats_visualization,
          o_feature-table-summarize, o_feature-table-tabulate-seqs, o_phylogeny_alignment,
          o_phylogeny_masked_alignment, o_phylogeny_tree, o_phylogeny_rooted_tree, o_diversity_metrics_dir,
          o_alpha_rarefaction, o_classifier_sklearn, o_classifier_sklearn_visualization, o_taxa_barplot_visualization,
          o_feature_table_filter_samples_artifact, o_composition_table_visualization]