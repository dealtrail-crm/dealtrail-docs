## 작업 내용

web 레포의 Next.js Dockerfile을 작성하고, api 레포의 Spring Boot Dockerfile은 **제안**으로 api 레포에 이슈를 만든다 (infra는 api 레포에 쓰지 않는다).

- web: 멀티 스테이지 빌드, 비루트 실행, 이미지에 비밀값 없음. **Next.js 초기화({{F02}} 등 web 레포 첫 작업) 이후 착수**
- api 제안: JDK 빌드 → JRE 실행 멀티 스테이지, JVM 메모리 옵션(`-XX:MaxRAMPercentage`, t4g.small 2GB에서 web·DB와 공존), 비루트 실행, actuator health용 포트. api 레포에 `[BE]` Task 이슈로 생성하고 본문에 Dockerfile 제안 전문을 넣는다

- Epic: 없음 (인프라 이슈는 Milestone만 연결한다)
- 선행: {{IN1}}; web은 Next.js 초기화 이후
- 권장 순서: {{IN0}} → {{IN1}} → {{IN3}} → {{IN2}} → {{IN4}} → {{IN5}} → {{IN6}} → {{IN7}}

## 완료 조건

- [ ] web 레포에 Dockerfile이 커밋되고 로컬에서 `docker build`·실행이 된다 (두 OS)
- [ ] api 레포에 Dockerfile 제안 이슈가 생성되어 있다 (링크를 이 이슈에 남긴다)
- [ ] 이미지 크기와 빌드 시간을 PR에 적는다
- [ ] 해당 **학습 가이드**(infra 레포 `docs/learning/NNNN-주제.md`)를 작성·갱신하고 `docs/learning/README.md` 목록에 추가한다. 내용은 `.claude/agents/infra.md` "학습 가이드" 절(개념 / 결정과 이유 / 실제 구성 읽기 / 직접 해 보기(PowerShell·zsh) / 실수와 함정 / 점검 질문)을 따른다
- [ ] 변경에 따른 예상 월 비용을 PR에 적는다 (비용 변화가 없으면 "없음")

## 관련 문서

- HANDOFF: 1장 "인프라 구성", 2장 에이전트별 원칙 (infra)
- 지원하는 PRD AC: 없음
- 관련 ADR: api 레포 `docs/adr/` (생기면 링크)
