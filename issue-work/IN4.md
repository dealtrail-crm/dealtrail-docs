## 작업 내용

Terraform 기반을 만든다: 원격 state(S3 버킷 + 잠금), GitHub Actions가 키 없이 AWS에 접근하는 OIDC 역할, 월 $30 예산 알림.

- 새 AWS 계정은 사용자가 만든다 (Paid plan). 예산 알림을 **가장 먼저** 만든다
- `terraform plan` 결과를 사용자에게 설명하고 **승인 뒤에만 apply**한다 (infra는 직접 실행하지 않는다)
- 비밀값·계정 ID는 코드에 하드코딩하지 않는다

- Epic: 없음 (인프라 이슈는 Milestone만 연결한다)
- 선행: {{IN0}}; 사용자: AWS 계정 생성
- 권장 순서: {{IN0}} → {{IN1}} → {{IN3}} → {{IN2}} → {{IN4}} → {{IN5}} → {{IN6}} → {{IN7}}

## 완료 조건

- [ ] 원격 state(S3)가 동작하고 로컬 두 OS에서 `terraform init`·`plan`이 된다
- [ ] GitHub OIDC 역할로 infra 레포 워크플로가 키 없이 AWS에 인증한다 (최소 권한)
- [ ] 월 $30 예산 알림이 사용자 이메일로 동작함을 확인했다 (테스트 알림 또는 콘솔 확인)
- [ ] plan 설명 → 사용자 승인 → apply 절차가 PR·이슈 코멘트에 남아 있다
- [ ] 해당 **학습 가이드**(infra 레포 `docs/learning/NNNN-주제.md`)를 작성·갱신하고 `docs/learning/README.md` 목록에 추가한다. 내용은 `.claude/agents/infra.md` "학습 가이드" 절(개념 / 결정과 이유 / 실제 구성 읽기 / 직접 해 보기(PowerShell·zsh) / 실수와 함정 / 점검 질문)을 따른다
- [ ] 변경에 따른 예상 월 비용을 PR에 적는다 (비용 변화가 없으면 "없음")

## 관련 문서

- HANDOFF: 1장 "인프라 구성", 2장 에이전트별 원칙 (infra)
- 지원하는 PRD AC: 없음
- 관련 ADR: api 레포 `docs/adr/` (생기면 링크)
