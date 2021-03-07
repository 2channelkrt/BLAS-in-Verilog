# BLAS-in-Verilog
BLAS-in-verilog implements representitive "fixed point single-precision vector/matrix operations" included in BLAS.

This work was part of the research project conducted in the university lab, which targets implementation of process-in-memory ([PIM](https://en.wikipedia.org/wiki/In-memory_processing)) in high-bandwidth memory ([HBM](https://en.wikipedia.org/wiki/High_Bandwidth_Memory)). Original work also features memory controller and interconnection module along with the provided 'BLAS-in-Verilog', but is not disclosed to the public.

## Terminology

### BLAS
BLAS stands for "Basic Linear Algebra Subprograms", Introduced by NASA in 1977.
See its [site](http://www.netlib.org/blas/) or original [paper](https://ntrs.nasa.gov/archive/nasa/casi.ntrs.nasa.gov/19780018835.pdf)

### Levels
BLAS divides various linear algebra operations into 3 different groups, called "levels", based on the type of operands used in the operation.
There are 3 levels, from level 1 to level 3.
* Level 1 includes vector to vector operations (vector additions etc)
* Level 2 includes matrix to vector opeartions (matrix-vector multiplications etc)
* Level 3 inlcudes matrix to matrix operations (matrix multiplications etc)

### Precision

Precision specifies how precisely can this operation safely handles the given calculation without the loss of values on the least-significant byte (LSB) side during the calculation. Since BLAS-in-Verilog is using fixed point operation, precision acts as how 'big' numbers can be given as an input to this implenetation.

* Single precision: 32-bit
* Double precision: 64-bit

# Implementation

Each file implements one BLAS operation, and type of the operation is specified within the file name. Each operation has inputs for each operands and an output for the operation result. Each input operands and output has valid bit acting as data strobe.

saxpy does vector/vector additions<br/>
![saxpy_image](https://github.com/2channelkrt/BLAS-in-Verilog/blob/master/assets/saxpy.jpg)<br/>
sgemv does matrix/vector multiplications<br/>
![sgemv_image](https://github.com/2channelkrt/BLAS-in-Verilog/blob/master/assets/sgemv.jpg)<br/>
sgemm does matrix/matrix multiplication<br/>
![sgemm_image](https://github.com/2channelkrt/BLAS-in-Verilog/blob/master/assets/sgemm.jpg)
