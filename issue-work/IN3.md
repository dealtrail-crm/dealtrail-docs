## 작업 내용

GitHub Actions **재사용 워크플로**(`workflow_call`)를 infra 레포에 두고, 각 앱 레포에는 짧은 호출 워크플로만 둔다.

- web: lint · build · test. web 레포의 호출 워크플로는 infra가 직접 커밋
- api: `gradle test` (Java 21, Gradle 캐시). api 레포의 호출 워크플로는 **제안**으로 api 레포에 `[BE]` Task 이슈를 만든다 (본문에 워크플로 전문)
- PR과 main 푸시에서 실행. 캐시로 반복 실행 시간을 줄인다

- Epic: 없음 (인프라 이슈는 Milestone만 연결한다)
- 선행: {{IN1}}
- 권장 순서: {{IN0}} → {{IN1}} → {{IN3}} → {{IN2}} → {{IN4}} → {{IN5}} → {{IN6}} → {{IN7}}

## 완료 조건

- [ ] infra 레포에 web·api용 재사용 워크플로가 있고, web 레포 PR에서 lint·build·test가 돈다
- [ ] api 레포에 호출 워크플로 제안 이슈가 생성되어 있다 (링크를 이 이슈에 남긴다)
- [ ] 워크플로가 Windows·macOS 로컬 명령과 같은 명령을 쓴다 (한쪽 OS 전용 스크립트 없음)
- [ ] 해당 **학습 가이드**(infra 레포 `docs/learning/NNNN-주제.md`)를 작성·갱신하고 `docs/learning/README.md` 목록에 추가한다. 내용은 `.claude/agents/infra.md` "학습 가이드" 절(개념 / 결정과 이유 / 실제 구성 읽기 / 직접 해 보기(PowerShell·zsh) / 실수와 함정 / 점검 질문)을 따른다
- [ ] 변경에 따른 예상 월 비용을 PR에 적는다 (비용 변화가 없으면 "없음")

## 관련 문서

- HANDOFF: 1장 "인프라 구성", 2장 에이전트별 원칙 (infra)
- 지원하는 PRD AC: 없음
- 관련 ADR: api 레포 `docs/adr/` (생기면 링크)
