## 작업 내용

로컬 개발용 Docker Compose(PostgreSQL)와 infra 레포 README를 만든다. 사용자(백엔드)와 frontend가 Windows·macOS 어디서든 `docker compose up` 한 번으로 DB를 띄울 수 있어야 한다.

- 로컬 Compose: PostgreSQL 컨테이너, 볼륨, 포트, 기본 DB·사용자. 비밀값은 `.env.example`로 예시만 두고 실제 값은 커밋하지 않는다
- README: 레포 구조도, 선택한 인프라 구조도(EC2+Compose+Caddy), 월 비용표, 자주 쓰는 명령(PowerShell·zsh 둘 다), 학습 가이드 목록 링크
- `.gitattributes`(`* text=auto eol=lf`)·`.editorconfig`가 없으면 함께 추가

- Epic: 없음 (인프라 이슈는 Milestone만 연결한다)
- 선행: {{IN0}}
- 권장 순서: {{IN0}} → {{IN1}} → {{IN3}} → {{IN2}} → {{IN4}} → {{IN5}} → {{IN6}} → {{IN7}}

## 완료 조건

- [ ] Windows(PowerShell)와 macOS(zsh)에서 `docker compose up`으로 PostgreSQL이 기동되고 Spring 로컬 설정에서 접속할 수 있다
- [ ] 비밀값이 커밋되지 않는다 (`.env.example`만)
- [ ] README에 구조도·월 비용표·명령(두 OS)이 있다
- [ ] 해당 **학습 가이드**(infra 레포 `docs/learning/NNNN-주제.md`)를 작성·갱신하고 `docs/learning/README.md` 목록에 추가한다. 내용은 `.claude/agents/infra.md` "학습 가이드" 절(개념 / 결정과 이유 / 실제 구성 읽기 / 직접 해 보기(PowerShell·zsh) / 실수와 함정 / 점검 질문)을 따른다
- [ ] 변경에 따른 예상 월 비용을 PR에 적는다 (비용 변화가 없으면 "없음")

## 관련 문서

- HANDOFF: 1장 "인프라 구성", 2장 에이전트별 원칙 (infra)
- 지원하는 PRD AC: 없음 (개발 환경)
- 관련 ADR: api 레포 `docs/adr/` (생기면 링크)
