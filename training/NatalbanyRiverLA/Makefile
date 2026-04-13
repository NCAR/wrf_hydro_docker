tag=wrfhydro/training:lsu_2026

all: build

build:
	docker build -t ${tag} .

run:
	docker run -it ${tag}

deploy:
	docker push ${tag}
