#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow
requirements:
  - class: MultipleInputFeatureRequirement
inputs:
  metadata_file:
    type: File
  pre_demux_file:
    type: File?
  post_demux_file:
    type: File?
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
  dada2_trim_left_f:
    type: int
    default: 13
  dada2_trunc_len_f:
    type: int
    default: 150
  dada2_trim_left_r:
    type: int
    default: 13
  dada2_trunc_len_r:
    type: int
    default: 150
  dada2_rep_seq_artifact:
    type: string
    default: rep-seqs.qza
  dada2_table_artifact:
    type: string
    default: table.qza
  dada2_stats_artifact:
    type: string
    default: stats-dada2.qza
  dada2_num_of_threads:
    type: int
    default: 1
  metadata_stats_visualization:
    type: string
    default: stats-dada2.qzv
  feature_table_summarize_visualization:
    type: string
    default: table.qzv
  feature_table_tabulate_seqs_visualization:
    type: string
    default: rep-seqs.qzv
  phylogeny_alignment_artifact:
    type: string
    default: aligned-rep-seqs.qza
  phylogeny_masked_alignment_artifact:
    type: string
    default: masked-aligned-rep-seqs.qza
  phylogeny_tree_artifact:
    type: string
    default: unrooted-tree.qza
  phylogeny_rooted_tree_artifact:
    type: string
    default: rooted-tree.qza
  diversity_sampling_depth:
    type: int
    default: 1103
  diversity_metrics_dir:
    type: string
    default: core-metrics-results
  rarefaction_max_depth:
    type: int
    default: 4000
  rarefaction_visualization:
    type: string
    default: alpha-rarefaction.qzv
  classifier_sklearn_artifact:
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
  # composition_ancom:
  #   type: string
  #   default: Subject
  # composition_ancom_visualization:
  #   type: string
  #   default: ancom-Subject.qzv
  # alpha_file_to_search_faith:
  #   type: string
  #   default: faith_pd_vector.qza
  # alpha_visualization_faith:
  #   type: string
  #   default: faith-pd-group-significance.qzv
  # alpha_file_to_search_evenness:
  #   type: string
  #   default: evenness_vector.qza
  # alpha_visualization_evenness:
  #   type: string
  #   default: evenness-group-significance.qzv
outputs: 
  # # o_artifact_tools_import:
  # #   type: File
  # #   outputSource: qiime-tools-import/artifact_tools_import
  o_demux_artifact:
    type: File?
    outputSource: qiime-demux-emp-paired/demux
  o_demux_details_artifact:
    type: File?
    outputSource: qiime-demux-emp-paired/demux_details
  # # o_demux_summarize_artifact:
  # #   type: File
  # #   outputSource: qiime-demux-summarize/demux_visualization
  o_dada2_rep_seq_artifact:
    type: File
    outputSource: qiime-dada2-denoise-paired/rep_seq
  o_dada2_table_artifact:
    type: File
    outputSource: qiime-dada2-denoise-paired/table
  o_dada2_denoising_stats_artifact:
    type: File
    outputSource: qiime-dada2-denoise-paired/denoising_stats
  # # o_metadata_stats_visualization:
  # #   type: File
  # #   outputSource: qiime-metadata-tabulate/stats_visualization 
  # o_feature_table_summarize_visualization:
  #   type: File
  #   outputSource: qiime-feature-table-summarize/table_visualization
  # o_feature_table_tabulate_seqs_visualization:
  #   type: File
  #   outputSource: qiime-feature-table-tabulate-seqs/rep_seqs_visualization
  o_phylogeny_alignment_artifact:
    type: File
    outputSource: qiime-phylogeny-align-to-tree-mafft-fasttree/alignment
  o_phylogeny_masked_alignment_artifact:
    type: File
    outputSource: qiime-phylogeny-align-to-tree-mafft-fasttree/masked_alignment
  o_phylogeny_unrooted_tree_artifact:
    type: File
    outputSource: qiime-phylogeny-align-to-tree-mafft-fasttree/tree
  o_phylogeny_rooted_tree_artifact:
    type: File
    outputSource: qiime-phylogeny-align-to-tree-mafft-fasttree/rooted_tree
  o_diversity_metrics_dir:
    type: Directory
    outputSource: qiime-diversity-core-metrics-phylogenetic/phylogenetic_metrics_dir
  # o_alpha_rarefaction_visualization:
  #   type: File
  #   outputSource: qiime-diversity-alpha-rarefaction/alpha_rarefaction_visualization
  o_classifier_sklearn_artifact:
    type: File
    outputSource: qiime-feature-classifier-classify-sklearn/classification
  # o_classifier_sklearn_visualization:
  #   type: File
  #   outputSource: qiime-classifier-sklearn-visualization/stats_visualization
  # o_taxa_barplot_visualization:
  #   type: File
  #   outputSource: qiime-taxa-barplot/visualization
  # o_feature_table_filter_samples_artifact:
  #   type: File
  #   outputSource: qiime-feature-table-filter-samples/filtered_table
  # o_composition_table_visualization:
  #   type: File
  #   outputSource: qiime-composition-add-pseudocount/composition_table
  # o_composition_ancom:
  #   type: File
  #   outputSource: qiime-composition-ancom/visualization
  

steps:
  decide_command_for_demux:
    run: ../wrappers/check-for-demux.cwl
    in:
      file_multiplexed: pre_demux_file
      file_demultiplexed: post_demux_file
    out: [demux_command, file_demultiplexed_seq]

  qiime-demux-emp-paired:
    run: ../wrappers/demux-emp-paired.cwl
    in:
      command_to_execute: decide_command_for_demux/demux_command
      input_seq: pre_demux_file
      metadata_file: metadata_file
      barcode_column: demux_barcode_column
      output_demux: demux_artifact
      output_demux_details: demux_details_artifact
    out: [demux, demux_details]

  return_demultiplexed_file:
    run: ../wrappers/check-for-demux.cwl
    in:
      file_multiplexed: qiime-demux-emp-paired/demux
      file_demultiplexed: post_demux_file
    out: [demux_command, file_demultiplexed_seq]

  # qiime-demux-summarize:
  #   run: ../wrappers/demux-summarize.cwl
  #   in:
  #     input_data: qiime-demux-emp-paired/demux
  #     output_visualization: demux_visualization
  #   out: [demux_visualization]

  qiime-dada2-denoise-paired:
    run: ../wrappers/dada2-denoise-paired.cwl
    in: 
      input_demux: return_demultiplexed_file/file_demultiplexed_seq
      trim_left_f: dada2_trim_left_f
      trunc_len_f: dada2_trunc_len_f
      trim_left_r: dada2_trim_left_r
      trunc_len_r: dada2_trunc_len_r
      num_of_threads: dada2_num_of_threads
      output_rep_seq: dada2_rep_seq_artifact
      output_table: dada2_table_artifact
      output_denoising_stats: dada2_stats_artifact
    out: [rep_seq, table, denoising_stats]

  # qiime-dada2-denoise-paired:
  #   run: ../wrappers/dada2-denoise-single.cwl
  #   in: 
  #     input_demux: qiime-demux-emp-paired/demux
  #     trim_left: dada2_trim_left_f
  #     trunc_len: dada2_trunc_len_f
  #     output_rep_seq: dada2_rep_seq
  #     output_table: dada2_table_artifact
  #     output_denoising_stats: dada2_stats_artifact
  #   out: [rep_seq, table, denoising_stats]
  # qiime-metadata-tabulate:
  #   run: ../wrappers/metadata-tabulate.cwl
  #   in:
  #     input_stats_file: qiime-dada2-denoise-paired/denoising_stats
  #     output_stats_visualization: metadata_stats_visualization
  #   out: [stats_visualization]

  # qiime-feature-table-summarize:
  #   run: ../wrappers/feature-table-summarize.cwl
  #   in:
  #     input_table: qiime-dada2-denoise-paired/table
  #     input_metadata: metadata_file
  #     output_table_visualization: feature_table_summarize_visualization
  #   out: [table_visualization]

  # qiime-feature-table-tabulate-seqs:
  #   run: ../wrappers/tabulate-seqs.cwl
  #   in: 
  #     input_rep_seqs: qiime-dada2-denoise-paired/rep_seq
  #     output_rep_seqs_visualization: feature_table_tabulate_seqs_visualization
  #   out: [rep_seqs_visualization]

  qiime-phylogeny-align-to-tree-mafft-fasttree:
    run: ../wrappers/align-to-tree-mafft-fasttree.cwl
    in:
      input_rep_seqs: qiime-dada2-denoise-paired/rep_seq
      output_alignment: phylogeny_alignment_artifact
      output_masked_alignment: phylogeny_masked_alignment_artifact
      output_tree: phylogeny_tree_artifact
      output_rooted_tree: phylogeny_rooted_tree_artifact
    out: [alignment, masked_alignment, tree, rooted_tree]

  qiime-diversity-core-metrics-phylogenetic:
    run: ../wrappers/core-metrics-phylogenetic.cwl
    in:
      input_rooted_tree: qiime-phylogeny-align-to-tree-mafft-fasttree/rooted_tree
      input_table: qiime-dada2-denoise-paired/table
      input_sampling_depth: diversity_sampling_depth
      input_metadata: metadata_file
      output_dir: diversity_metrics_dir
    out: [phylogenetic_metrics_dir]

  # qiime-diversity-alpha-rarefaction:
  #   run: ../wrappers/alpha-rarefaction.cwl
  #   in:
  #     input_table: qiime-dada2-denoise-paired/table
  #     input_phylogeny: qiime-phylogeny-align-to-tree-mafft-fasttree/rooted_tree
  #     input_max_depth: rarefaction_max_depth
  #     input_metadata: metadata_file
  #     output_visualization: rarefaction_visualization
  #   out: [alpha_rarefaction_visualization]

  qiime-feature-classifier-classify-sklearn:
    run: ../wrappers/classify-sklearn.cwl
    in:
      input_classifier: classifier
      input_reads: qiime-dada2-denoise-paired/rep_seq
      output_classification: classifier_sklearn_artifact
    out: [classification]

  # qiime-classifier-sklearn-visualization:
  #   run: ../wrappers/metadata-tabulate.cwl
  #   in:
  #     input_stats_file: qiime-feature-classifier-classify-sklearn/classification
  #     output_stats_visualization: classifier_sklearn_visualization
  #   out: [stats_visualization]

  # qiime-taxa-barplot:
  #   run: ../wrappers/taxa-barplot.cwl
  #   in: 
  #     input_table: qiime-dada2-denoise-paired/table
  #     input_taxonomy: qiime-feature-classifier-classify-sklearn/classification
  #     input_metadata: metadata_file
  #     output_visualization: taxa_barplot_visualization
  #   out: [visualization]
  # qiime-feature-table-filter-samples:
  #   run: ../wrappers/filter-samples.cwl
  #   in: 
  #     input_table: qiime-dada2-denoise-paired/table
  #     input_metadata: metadata_file
  #     input_expr: feature_table_filter_samples
  #     output_filtered_table: feature_table_filter_samples_artifact
  #   out: [filtered_table]
  # qiime-composition-add-pseudocount:
  #   run: ../wrappers/add-pseudocount.cwl
  #   in:
  #     input_table: qiime-feature-table-filter-samples/filtered_table
  #     output_composition_table: composition_add_pseudocount_artifact
  #   out: [composition_table]
  # qiime-vsearch-join-pairs:
  #   run: ../wrappers/vsearch-join-pairs.cwl
  #   in: 
  #     input_data: qiime-demux-emp-paired/demux
  #   out: [joined-sequences]
  # qiime-composition-ancom:
  #   run: ../wrappers/composition-ancom.cwl
  #   in:
  #     input_table: qiime-composition-add-pseudocount/composition_table
  #     input_metadata: metadata_file
  #     input_metadata_column: composition_ancom
  #     output_visualization: composition_ancom_visualization
  #   out: [visualization]
  # search-for-file-faith:
  #   run: ../wrappers/search-in-dir.cwl
  #   in: 
  #     directory: qiime-diversity-core-metrics-phylogenetic/phylogenetic_metrics_dir
  #     file_to_search: alpha_file_to_search_faith
  #   out: [output_file]
  # qiime-alpha-group-significance-faith:
  #   run: ../wrappers/alpha-group-significance.cwl
  #   in:
  #     input_alpha-diversity: search-for-file-faith/output_file
  #     input_metadata: metadata_file
  #     output_visualization: alpha_visualization_faith
  #   out: [visualization]
  # search-for-file-evenness:
  #   run: ../wrappers/search-in-dir.cwl
  #   in: 
  #     directory: qiime-diversity-core-metrics-phylogenetic/phylogenetic_metrics_dir
  #     file_to_search: alpha_file_to_search_evenness
  #   out: [output_file]
  # qiime-alpha-group-significance-evenness:
  #   run: ../wrappers/alpha-group-significance.cwl
  #   in:
  #     input_alpha-diversity: search-for-file-evenness/output_file
  #     input_metadata: metadata_file
  #     output_visualization: alpha_visualization_evenness
  #   out: [visualization]