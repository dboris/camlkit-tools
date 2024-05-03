.PHONY: build test gen-cf gen-fnd gen-ak gen-wk show-libs show-fnd show-ak clean

FW := /System/Library/Frameworks
CORE_FOUNDATION := $(FW)/CoreFoundation.framework/Versions/A/CoreFoundation
FOUNDATION := $(FW)/Foundation.framework/Versions/C/Foundation
APPKIT := $(FW)/AppKit.framework/Versions/C/AppKit
WEBKIT := $(FW)/WebKit.framework/Versions/A/WebKit

build:
	@dune build @default

test:
	@dune runtest --root .

foundation/gen/NSObject.ml:
	cd foundation/gen && dune exec generate -- -methods NSObject

foundation/gen/NSString.ml:
	cd foundation/gen && dune exec generate -- -methods NSString

gen-cf: foundation/gen/NSObject.ml
	cd foundation/gen && dune exec generate -- -classes $(CORE_FOUNDATION)

gen-fnd:
	cd foundation/gen && dune exec generate -- -classes $(FOUNDATION)

gen-ak:
	cd appkit/gen && dune exec generate -- -classes $(APPKIT) -foundation

gen-wk:
	cd webkit/gen && dune exec generate -- -classes $(WEBKIT) -foundation

show-libs:
	@dune exec browser -- -libs

show-fnd:
	@dune exec browser -- -classes $(FOUNDATION)

show-ak:
	@dune exec browser -- -classes $(APPKIT)

clean:
	@dune clean
