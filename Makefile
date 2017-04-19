tests = tests
module = atropos
pytestops =
#pytestops = "-v -s"
repo = jdidion/atropos

BUILD = python setup.py build_ext -i && python setup.py install
TEST = py.test $(pytestops) $(tests)

all:
	$(BUILD)
	$(TEST)

install:
	$(BUILD)

test:
	$(TEST)

release:
	# tag
	git tag $(version)
	# build
	$(BUILD)
	$(TEST)
	python setup.py sdist bdist_wheel
	# release
	twine register dist/$(module)-$(version).tar.gz
	twine upload dist/$(module)-$(version).tar.gz
	git push origin --tags

docs:
	make -C docs api
	make -C docs html

readme:
	pandoc --from=markdown --to=rst --output=README.rst README.md

lint:
	pylint $(module)

clean:
	rm -Rf __pycache__ \
	       **/__pycache__/* \
		   **/*.c \
		   **/*.so \
		   **/*.pyc \
		   dist \
		   build \
		   .adapters \
		   atropos.egg-info

docker:
	# build
	docker build -f Dockerfile -t $(repo):$(version) .
	# add alternate tags
	docker tag $(repo):$(version) jdidion/atropos:latest
	# push to Docker Hub
	docker login -e johndidion@gmail.com -u jdidion && \
	docker push $(repo)