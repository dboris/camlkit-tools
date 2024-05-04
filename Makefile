.PHONY: build gen-cf gen-fnd gen-ak gen-wk show-libs show-fnd show-ak clean

FW := /System/Library/Frameworks
CORE_FOUNDATION := $(FW)/CoreFoundation.framework/Versions/A/CoreFoundation
FOUNDATION := $(FW)/Foundation.framework/Versions/C/Foundation
APPKIT := $(FW)/AppKit.framework/Versions/C/AppKit
WEBKIT := $(FW)/WebKit.framework/Versions/A/WebKit

build:
	@dune build @default

gen-bs:
	@dune exec bs-to-ml < data/AppKit.bridgesupport > data/appkit_.ml

foundation/gen/NSObject.ml:
	cd foundation/gen && dune exec generate-ml -- -methods NSObject

foundation/gen/NSString.ml:
	cd foundation/gen && dune exec generate-ml -- -methods NSString

gen-cf: foundation/gen/NSObject.ml
	cd foundation/gen && dune exec generate-ml -- -classes $(CORE_FOUNDATION)

gen-fnd:
	cd foundation/gen && dune exec generate-ml -- -classes $(FOUNDATION)

gen-ak:
	cd appkit/gen && dune exec generate-ml -- -classes $(APPKIT) -foundation

gen-wk:
	cd webkit/gen && dune exec generate-ml -- -classes $(WEBKIT) -foundation

show-libs:
	@dune exec inspect-rt -- -libs

show-fnd:
	@dune exec inspect-rt -- -classes $(FOUNDATION)

show-ak:
	@dune exec inspect-rt -- -classes $(APPKIT)

clean:
	@dune clean
