import angr
import claripy
import sys

def main(argv):
	path_to_binary = "./bomb" # path of the binary program
	project = angr.Project(path_to_binary)
	start_addr = 0x40110b
	initial_state = project.factory.blank_state(addr=start_addr)

	size_in_bits = 32
	input0 = claripy.BVS("input0", size_in_bits)
	input1 = claripy.BVS("input1", size_in_bits)
	input2 = claripy.BVS("input2", size_in_bits)
	input3 = claripy.BVS("input3", size_in_bits)
	input4 = claripy.BVS("input4", size_in_bits)
	input5 = claripy.BVS("input5", size_in_bits)

	initial_state.regs.rbp = initial_state.regs.rsp
	initial_state.regs.rsp -= 0x50
	initial_state.mem[initial_state.regs.rsp ].int = input0
	initial_state.mem[initial_state.regs.rsp + 0x4].int = input1
	initial_state.mem[initial_state.regs.rsp + 0x8].int = input2
	initial_state.mem[initial_state.regs.rsp + 0xc].int = input3
	initial_state.mem[initial_state.regs.rsp + 0x10].int = input4
	initial_state.mem[initial_state.regs.rsp + 0x14].int = input5
	
	simulation = project.factory.simgr(initial_state)

	good_address = 0x4011f7
	avoid_address = 0x40143a
	simulation.explore(find=good_address, avoid=avoid_address)
  
	if simulation.found:
		solution_state = simulation.found[0]
		#solution = solution_state.posix.dumps(sys.stdin.fileno())
		solution0 = solution_state.solver.eval(input0)
		solution1 = solution_state.solver.eval(input1)
		solution2 = solution_state.solver.eval(input2)
		solution3 = solution_state.solver.eval(input3)
		solution4 = solution_state.solver.eval(input4)
		solution5 = solution_state.solver.eval(input5)
		print("[+] Success! Solution is: {} {} {} {} {} {}".format(solution0, solution1, solution2, solution3, solution4, solution5))
  
	else:
		raise Exception('Could not find the solution')

if __name__ == '__main__':
	main(sys.argv)
