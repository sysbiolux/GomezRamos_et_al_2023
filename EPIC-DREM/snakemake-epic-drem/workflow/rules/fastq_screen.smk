rule fastq_screen:
    input: "data/rna/fastq/d0_rep1_r1.fastq.gz"
    output:
        txt="qc/fastq_screen/{sample}-{unit}.fastq_screen.txt",
        png="qc/fastq_screen/{sample}-{unit}.fastq_screen.png"
    conda: "envs/fastq.yaml"
    params:
        fastq_screen_config = {
            'database': {
                'human': {
                  'bowtie2': '/work/projects/stitchit_lrrk2/snakemake-epic-drem/FastQ_Screen_Genomes/Human/Homo_sapiens.GRCh38'},
                'mouse': {
                  'bowtie2': '/work/projects/stitchit_lrrk2/snakemake-epic-drem/FastQ_Screen_Genomes/Mouse/Mus_musculus.GRCm38'},
                'rat':{
                  'bowtie2': '/work/projects/stitchit_lrrk2/snakemake-epic-drem/FastQ_Screen_Genomes/Rat/Rnor_6.0'},
                'drosophila':{
                  'bowtie2': '/work/projects/stitchit_lrrk2/snakemake-epic-drem/FastQ_Screen_Genomes/Drosophila/BDGP6'},
                'worm':{
                  'bowtie2': '/work/projects/stitchit_lrrk2/snakemake-epic-drem/FastQ_Screen_Genomes/Worm/Caenorhabditis_elegans.WBcel235'},
                'yeast':{
                  'bowtie2': '/work/projects/stitchit_lrrk2/snakemake-epic-drem/FastQ_Screen_Genomes/Yeast/Saccharomyces_cerevisiae.R64-1-1'},
                'arabidopsis':{
                  'bowtie2': '/work/projects/stitchit_lrrk2/snakemake-epic-drem/FastQ_Screen_Genomes/Arabidopsis/Arabidopsis_thaliana.TAIR10'},
                'ecoli':{
                  'bowtie2': '/work/projects/stitchit_lrrk2/snakemake-epic-drem/FastQ_Screen_Genomes/E_coli/Ecoli'},
                'rRNA':{
                  'bowtie2': '/work/projects/stitchit_lrrk2/snakemake-epic-drem/FastQ_Screen_Genomes/rRNA/GRCm38_rRNA'},
                'adapters':{
                  'bowtie2': '/work/projects/stitchit_lrrk2/snakemake-epic-drem/FastQ_Screen_Genomes/Adapters/Contaminants'},
                'mycoplasma':{
                  'bowtie2': '/work/projects/stitchit_lrrk2/snakemake-epic-drem/FastQ_Screen_Genomes/Mycoplasma/mycoplasma'}
		 },
        	'aligner_paths': {'bowtie2': '/work/projects/stitchit_lrrk2/snakemake-epic-drem/workflow/.snakemake/conda/4ac2b283/bin/bowtie2'}   
                 }
                },
        subset=100000,
        aligner='bowtie2'
    threads: 8
    wrapper:
        "0.45.1/bio/fastq_screen"
