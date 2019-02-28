# Copyright 2019 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and

load("@rules_maven//:coursier.bzl", "coursier_fetch")
load("@rules_maven//:specs.bzl", "maven", "parse", "json")

REPOSITORY_NAME = "maven"

def maven_install(
        name = REPOSITORY_NAME,
        repositories = [],
        artifacts = [],
        fetch_sources = False):

    repositories_json_strings = []
    for repository in parse.parse_repository_spec_list(repositories):
        repositories_json_strings.append(json.write_repository_spec(repository))

    artifacts_json_strings = []
    for artifact in parse.parse_artifact_spec_list(artifacts):
        artifacts_json_strings.append(json.write_artifact_spec(artifact))

    coursier_fetch(
        name = name,
        repositories = repositories_json_strings,
        artifacts = artifacts_json_strings,
        fetch_sources = fetch_sources,
    )

def maven_artifact(fqn):
    return "@%s//:%s" % (REPOSITORY_NAME, _escape(fqn))

def artifact(fqn, repository_name = REPOSITORY_NAME):
    return "@%s//:%s" % (repository_name, _escape(fqn))

def _escape(string):
    return string.replace(".", "_").replace("-", "_").replace(":", "_")
