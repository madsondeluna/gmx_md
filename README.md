# Automation of Molecular Simulations with GROMACS

This project contains a Bash script that automates the entire workflow for preparing and running molecular simulations using GROMACS. This solution is ideal for researchers in molecular modeling who seek to save time and reduce manual errors during the process.

## Features

- Automatic detection of `.pdb` files in the current directory.
- Automated workflow for:
  - File preparation.
  - Solvation and ion addition.
  - Energy minimization.
  - Molecular dynamics under NVT and NPT conditions.
  - Production simulation.
- GPU compatibility for more efficient simulations.

## Requirements

Ensure the following are installed in your environment:

- [GROMACS](http://www.gromacs.org/) version 2020 or later.
- Bash Shell (available on Linux and macOS distributions).
- Required `.mdp` files:
  - `ions.mdp`
  - `minim.mdp`
  - `nvt.mdp`
  - `npt.mdp`
  - `md.mdp`

### Required Files

- `.pdb` file containing the molecular structure to be simulated.
- Appropriate topology for GROMACS (`topol.top`).
- Solvent coordinate file (`spc216.gro`).

## How to Use

1. **Clone this repository**:
   ```bash
   git clone https://github.com/madsondeluna/gmx_md.git
   cd gmx_md
   ```

2. **Place the `.pdb` file in the project directory**.

3. **Ensure that the `.mdp` files are available** in the same directory.

4. **Make the script executable**:
   ```bash
   chmod +x gmx.sh
   ```

5. **Run the script**:
   ```bash
   ./gmx.sh
   ```

6. **Expected Output**:
   - Intermediate and final results will be saved in the working directory.
   - Important files include:
     - `em.gro`: Coordinates after energy minimization.
     - `nvt.gro`: Coordinates after NVT equilibration.
     - `npt.gro`: Coordinates after NPT equilibration.
     - `md_0_1.xtc`: Production simulation trajectory.
     - `md_0_1.edr`: Energy data.
     - `md_0_1.log`: Production simulation log.

## Script Structure

```bash
#!/bin/bash

# Automatically search for the .pdb file in the current directory
PDB_FILE=$(ls *.pdb 2>/dev/null | head -n 1)

# Check if the file was found
if [ -z "$PDB_FILE" ]; then
    echo "No .pdb file found in the current directory. Please ensure the file is present."
    exit 1
fi

# Remaining GROMACS commands automated...
```

The script is modular, allowing easy adjustments for different experimental scenarios.

## Customizations

- **Ion Concentration**:
  - Modify the `-conc` parameter in the ion addition step.
- **Simulation Box Configuration**:
  - Adjust the spacing of the box by modifying the `-d` parameter in the `editconf` step.
- **Simulation with Multiple GPUs**:
  - Adapt the `-gpu_id` parameter to use multiple GPUs as needed.

## Contributions

Contributions are welcome! Follow these steps:

1. Fork the repository.
2. Create a branch for your feature (`git checkout -b my-feature`).
3. Commit your changes (`git commit -m 'My new feature'`).
4. Push to the branch (`git push origin my-feature`).
5. Open a Pull Request.

## License

This project is licensed under the MIT License. See the `LICENSE` file for more details.

## Contact

- Author: Madson Aragão
- Email: [madsondeluna@gmail.com](mailto:madsondeluna@gmail.com)
- LinkedIn: [Madson Aragão](https://www.linkedin.com/in/madsonaragao/)

---

**Attention:** Ensure all required files are in the same directory before running the script to avoid unexpected errors. This project has been tested on Linux systems but can be adapted for other environments.
