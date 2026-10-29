## 작업 내용

CD: web·api 레포 main 머지 시 이미지를 GHCR에 푸시(태그: 커밋 SHA + latest)하고, SSM Run Command로 EC2에서 `docker compose pull && up`을 실행한다. 태그를 지정해 이전 이미지로 되돌리는 롤백 절차를 문서화한다.

- api 레포 워크플로는 제안·이슈로 전달한다 (infra는 api 레포에 쓰지 않는다)
- OIDC 역할({{IN4}})로 인증, 장기 키 없음
- 무중단 배포는 범위 밖 (재검토 조건은 HANDOFF 1장)

- Epic: 없음 (인프라 이슈는 Milestone만 연결한다)
- 선행: {{IN3}}, {{IN6}}
- 권장 순서: {{IN0}} → {{IN1}} → {{IN3}} → {{IN2}} → {{IN4}} → {{IN5}} → {{IN6}} → {{IN7}}

## 완료 조건

- [ ] web 레포 main 머지 → GHCR 푸시 → EC2 배포가 자동으로 된다. api는 제안 이슈가 생성되어 있다
- [ ] 특정 태그로 롤백하는 절차(두 OS 명령)가 학습 가이드에 있고 한 번 실제로 수행해 확인했다
- [ ] 배포 실패 시 알 수 있다 (워크플로 실패 알림)
- [ ] 이미지에 비밀값이 없다
- [ ] 해당 **학습 가이드**(infra 레포 `docs/learning/NNNN-주제.md`)를 작성·갱신하고 `docs/learning/README.md` 목록에 추가한다. 내용은 `.claude/agents/infra.md` "학습 가이드" 절(개념 / 결정과 이유 / 실제 구성 읽기 / 직접 해 보기(PowerShell·zsh) / 실수와 함정 / 점검 질문)을 따른다
- [ ] 변경에 따른 예상 월 비용을 PR에 적는다 (비용 변화가 없으면 "없음")

## 관련 문서

- HANDOFF: 1장 "인프라 구성", 2장 에이전트별 원칙 (infra)
- 지원하는 PRD AC: 없음
- 관련 ADR: api 레포 `docs/adr/` (생기면 링크)
