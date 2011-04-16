# iURM

iURM is a URM simulator (Unlimited Register Machine) for iOS.
Theoretical bases on [wikipedia](http://en.wikipedia.org/wiki/Counter_machine_models).
URM is used in Computational theory to prove function computability, it does not have any real implementations. 

The machine uses a limited set of basic instructions to operate. These instructions are enough to write programs that represent computable functions. Usually the state of the execution starts with the arguments in the initial registers, and the output is served the first register. Registers can be modified during execution. The set of instructions is:

- Z(n): set to 0 the register n
- S(n): add 1 to the register n
- T(m,n): move the content of the register m to the register n
- J(m,n,q): if the content of register m is equal to the content of register n go to instruction q

# License

Licensed under the New BSD License.

Copyright (c) 2011, Alberto De Bortoli
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of Alberto De Bortoli nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

## Resources

Here is the iURM [page](http://www.albertodebortoli.it/wordpress/iphone/iurm). Also, you can
find other works of mine on the Apple App Store [here](http://itunes.apple.com/us/artist/alberto-de-bortoli/id292413213).

More general info can be found on [my website](http://www.albertodebortoli.it), [and on Twitter](http://twitter.com/albertodebo).
