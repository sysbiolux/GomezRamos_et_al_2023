rule get_tepic:
  output: 
    tepic = "TEPIC-master/Code/TEPIC.sh",
    trap = "TEPIC-master/Code/TRAPmulti",
    pwm = "TEPIC-master/PWMs/2.1/JASPAR_PSEMs/{}".format(config["psems"])
  conda: "../envs_local/tepic_clean.yaml"
  shell:
    """
    wget  https://github.com/SchulzLab/TEPIC/archive/master.zip 
    unzip master.zip 
    rm master.zip
    cd TEPIC-master/Code
    g++ TRAPmulti.cpp -O3 -fopenmp -o TRAPmulti
    """

rule get_drem:
  output: "drem2/drem.jar"
  shell:
    """
    wget http://www.sb.cs.cmu.edu/drem/drem2.zip
    unzip drem2.zip
    rm drem2.zip
    """

rule get_idrem:
  output: "idrem-master/idrem.jar"
  shell:
    """
    wget https://github.com/phoenixding/idrem/archive/refs/heads/master.zip
    unzip master.zip
    rm master.zip
    mkdir lib
    ln -s idrem-master/lib/viz lib/viz
    """
