#!/bin/bash

# Procurar automaticamente pelo arquivo .pdb no diretório atual
PDB_FILE=$(ls *.pdb 2>/dev/null | head -n 1)

# Verificar se o arquivo foi encontrado
if [ -z "$PDB_FILE" ]; then
    echo "Nenhum arquivo .pdb encontrado no diretório atual. Certifique-se de que o arquivo está presente."
    exit 1
fi

echo "Usando o arquivo PDB: $PDB_FILE"

# Gerar os nomes de saída baseados no arquivo de entrada
BASE_NAME=${PDB_FILE%.*}

gmx pdb2gmx -f "$PDB_FILE" -o "${BASE_NAME}_processed.gro" -water spce -ignh <<EOF
13
EOF

gmx editconf -f "${BASE_NAME}_processed.gro" -o "${BASE_NAME}_newbox.gro" -c -d 1.0 -bt cubic

gmx solvate -cp "${BASE_NAME}_newbox.gro" -cs spc216.gro -o "${BASE_NAME}_solv.gro" -p topol.top

gmx grompp -f ions.mdp -c "${BASE_NAME}_solv.gro" -p topol.top -o ions.tpr -maxwarn 5

gmx genion -s ions.tpr -o "${BASE_NAME}_solv_ions.gro" -p topol.top -neutral -conc 0.15 -pname NA -nname CL <<EOF
13
EOF

gmx grompp -f minim.mdp -c "${BASE_NAME}_solv_ions.gro" -p topol.top -o em.tpr -maxwarn 5

gmx mdrun -v -deffnm em -s em.tpr

gmx grompp -f nvt.mdp -c em.gro -p topol.top -o nvt.tpr -r em.gro -maxwarn 5

gmx mdrun -deffnm nvt -v -s nvt.tpr -gpu_id "0"

gmx grompp -f npt.mdp -c nvt.gro -t nvt.cpt -p topol.top -o npt.tpr -r em.gro -maxwarn 5

gmx mdrun -deffnm npt -v -s npt.tpr -gpu_id "0"

gmx grompp -f md.mdp -c npt.gro -t npt.cpt -p topol.top -o md_0_1.tpr -maxwarn 5

gmx mdrun -deffnm md_0_1 -v -cpi checkpoint.cpt -pin on -resethway &