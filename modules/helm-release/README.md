# helm-release

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.this](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_atomic"></a> [atomic](#input\_atomic) | (선택) 설치 프로세스 실패시 차트를 제거 유무. Default: `false` | `bool` | `false` | no |
| <a name="input_chart"></a> [chart](#input\_chart) | (필수) 저장소 내에 설치할 차트 이름 | `string` | n/a | yes |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | (선택) 차트 버전. 지정하지 않을시 latest 버전으로 설치. | `string` | `null` | no |
| <a name="input_cleanup_on_fail"></a> [cleanup\_on\_fail](#input\_cleanup\_on\_fail) | (선택) 업그레이드 실패시 업그레이드에 생성된 새 리소스 삭제 유무. Default: `false` | `bool` | `false` | no |
| <a name="input_create_namespace"></a> [create\_namespace](#input\_create\_namespace) | (선택) Helm release 시 namespace 자동생성 여부. Default: `false` | `bool` | `false` | no |
| <a name="input_dependency_update"></a> [dependency\_update](#input\_dependency\_update) | (선택) 차트 설치전 종속성 업데이트 실행 유무. Default: `false` | `bool` | `false` | no |
| <a name="input_description"></a> [description](#input\_description) | (선택) Helm release 설명. | `string` | `null` | no |
| <a name="input_devel"></a> [devel](#input\_devel) | (선택) 차트의 개발버전 사용 유무. Default: `false` | `bool` | `false` | no |
| <a name="input_disable_openapi_validation"></a> [disable\_openapi\_validation](#input\_disable\_openapi\_validation) | (선택) Kubernetes OpenAPI 스키마에 대해 렌더링된 템플릿의 유효성을 검사. Default: `false` | `bool` | `false` | no |
| <a name="input_disable_webhooks"></a> [disable\_webhooks](#input\_disable\_webhooks) | (선택) web hook 실행 유무. Default: `false` | `bool` | `false` | no |
| <a name="input_force_update"></a> [force\_update](#input\_force\_update) | (선택) 업데이트 강제 삭제/재생성 할성화 유무. Default: `false` | `bool` | `false` | no |
| <a name="input_keyring"></a> [keyring](#input\_keyring) | (선택) `verify` 가 `true` 인 경우 확인 에 사용되는 공개키 위치. | `string` | `null` | no |
| <a name="input_lint"></a> [lint](#input\_lint) | (선택) 실행중 lint 를 실행할지 여부. Default: `false` | `bool` | `false` | no |
| <a name="input_max_history"></a> [max\_history](#input\_max\_history) | (선택) release 당 저장되는 버전 수. Default: `0` (no limit) | `number` | `0` | no |
| <a name="input_name"></a> [name](#input\_name) | (필수) Helm release 이름. | `string` | n/a | yes |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | (선택) Helm release namespace. Default: `default` | `string` | `"default"` | no |
| <a name="input_postrender"></a> [postrender](#input\_postrender) | (선택) helm이 매니페스트 콘텐츠를 변경할 수 있는 매니페스트를 렌더링한 후에 실행할 명령을 구성 | `any` | `{}` | no |
| <a name="input_recreate_pods"></a> [recreate\_pods](#input\_recreate\_pods) | (선택) 업그레이드/롤백 중 pod 재시작 유무. Default: `false` | `bool` | `false` | no |
| <a name="input_render_subchart_notes"></a> [render\_subchart\_notes](#input\_render\_subchart\_notes) | (선택) 설정시 상위차트와 함께 하위 차트 메모를 렌더링. Default: `true` | `bool` | `true` | no |
| <a name="input_replace"></a> [replace](#input\_replace) | (선택) 기록에 이름이 남아있는 경우 삭제된 release 인 경우에만 해당이름을 재사용 유무. Default: `false` | `bool` | `false` | no |
| <a name="input_repository"></a> [repository](#input\_repository) | (선택) Chart 가 있는 Repository URL. | `string` | n/a | yes |
| <a name="input_repository_ca_file"></a> [repository\_ca\_file](#input\_repository\_ca\_file) | (선택) 저장소 인증서 CA 파일 | `string` | `null` | no |
| <a name="input_repository_cert_file"></a> [repository\_cert\_file](#input\_repository\_cert\_file) | (선택) 저장소 인증서 파일 | `string` | `null` | no |
| <a name="input_repository_key_file"></a> [repository\_key\_file](#input\_repository\_key\_file) | (선택) 저장소 인증서 키 파일 | `string` | `null` | no |
| <a name="input_repository_password"></a> [repository\_password](#input\_repository\_password) | (선택) repository 로 접근 할 password | `string` | `null` | no |
| <a name="input_repository_username"></a> [repository\_username](#input\_repository\_username) | (선택) repository 로 접근 할 username. | `string` | `null` | no |
| <a name="input_reset_values"></a> [reset\_values](#input\_reset\_values) | (선택) 업그레이드 할대 chart 에 내장된 값으로 재성정 유무. Default: `false` | `bool` | `false` | no |
| <a name="input_reuse_values"></a> [reuse\_values](#input\_reuse\_values) | (선택) 업그레이드할때 마지막 release 값을 재사용 및 재정의 할지 유무. Default: `false` | `bool` | `false` | no |
| <a name="input_set"></a> [set](#input\_set) | (선택) 사용자 정의 값 YAML | `any` | `[]` | no |
| <a name="input_set_sensitive"></a> [set\_sensitive](#input\_set\_sensitive) | (선택) 계획의 diff에 노출되지 않는 값 yaml과 병합될 사용자 정의 민감한 값 | `any` | `[]` | no |
| <a name="input_skip_crds"></a> [skip\_crds](#input\_skip\_crds) | (선택) CRD 설치 유무. Default: `false` | `bool` | `false` | no |
| <a name="input_timeout"></a> [timeout](#input\_timeout) | (선택) Helm 설치 까지 기다리는 시간(초). Default: `300` | `number` | `300` | no |
| <a name="input_values"></a> [values](#input\_values) | (선택) Helm 설치기 전달할 값 목록. `-f` 옵션 사용처럼 순서대로 진행. | `list(string)` | `[]` | no |
| <a name="input_verify"></a> [verify](#input\_verify) | (선택) Helm 패키지를 설치하기 전 차트의 무결성을 확인 유무. Default: `false` | `bool` | `false` | no |
| <a name="input_wait"></a> [wait](#input\_wait) | (선택) 릴리스가 성공으로 표시되기전 모든 리소스가 준비 상태가 될때까지 기다림.  Default: `true` | `bool` | `true` | no |
| <a name="input_wait_for_jobs"></a> [wait\_for\_jobs](#input\_wait\_for\_jobs) | (선택) `wait` 가 `ture` 인 경우 릴리스가 성공으로 표시되기 전에 모든 작업이 완료될 때까지 기다림. Default: `false` | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_version"></a> [app\_version](#output\_app\_version) | application deploy version |
| <a name="output_chart"></a> [chart](#output\_chart) | chart 이름 |
| <a name="output_name"></a> [name](#output\_name) | release 이름 |
| <a name="output_namespace"></a> [namespace](#output\_namespace) | Kubernetes namespace 이름 |
| <a name="output_revision"></a> [revision](#output\_revision) | release revision |
| <a name="output_values"></a> [values](#output\_values) | helm values 값 |
| <a name="output_version"></a> [version](#output\_version) | chart version |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
