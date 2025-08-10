
build:
	mkdir -p out
	fasm src/main.asm out/main

run: build
	./out/main

clean:
	rmdir -r out
