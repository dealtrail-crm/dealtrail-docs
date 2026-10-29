## 작업 내용

인프라 구성 결정(HANDOFF 1장 "인프라 구성")의 근거를 AWS·Terraform을 모르는 사용자가 이해하고 설명할 수 있게 학습 가이드로 쓴다. 코드 작업은 없다. 이후 모든 인프라 이슈의 첫 읽을 것이 된다.

다룰 내용:
- 선택한 구성: EC2 한 대(t4g.small, 서울 리전) + Docker Compose(web·api·DB) + Caddy(HTTPS 종료, `/api/*` → Spring, 나머지 → Next.js)
- 버린 대안과 이유: ECS Fargate + ALB + RDS (비용 약 3배, 학습 부담), Lightsail, RDS (컨테이너 DB + 일일 EBS 스냅샷 7일로 대체)
- 파일 위치 규칙: Dockerfile·짧은 CI 호출 워크플로는 각 앱 레포(api 레포 파일은 사용자가 커밋), 재사용 워크플로·운영/로컬 Compose·Caddyfile·Terraform은 infra 레포
- 이미지 저장소 GHCR(public), 이미지에 비밀값을 넣지 않는 이유
- 방문자 IP 전달: Caddy가 `X-Forwarded-For`를 실제 접속 IP로 다시 쓰고 Spring은 `forward-headers-strategy=native`로 내부 프록시만 신뢰. 보안 그룹 80·443만. 대여·가입 요청은 브라우저가 `/api`를 직접 호출
- 정리 배치는 앱 내 스케줄러(외부 트리거 없음)
- 월 비용 약 $22의 산출 근거, 새 AWS 계정 생성·Paid plan·예산 알림(월 $30)을 가장 먼저 만드는 이유
- 재검토 조건: 서버 한 대로 부족해지거나 무중단 배포가 필요해지면 ECS

- Epic: 없음 (인프라 이슈는 Milestone만 연결한다)
- 선행: 없음
- 권장 순서: {{IN0}} → {{IN1}} → {{IN3}} → {{IN2}} → {{IN4}} → {{IN5}} → {{IN6}} → {{IN7}}

## 완료 조건

- [ ] `docs/learning/0001-인프라-구성-결정.md`(제목은 infra가 정함)에 위 내용이 모두 들어 있다
- [ ] 비용표: 선택 구성 vs ECS Fargate 구성의 월 비용 비교, 가정(리전·사용량·프리 티어 여부) 명시
- [ ] `docs/learning/README.md`에 목록과 권장 읽기 순서가 있다
- [ ] 해당 **학습 가이드**(infra 레포 `docs/learning/NNNN-주제.md`)를 작성·갱신하고 `docs/learning/README.md` 목록에 추가한다. 내용은 `.claude/agents/infra.md` "학습 가이드" 절(개념 / 결정과 이유 / 실제 구성 읽기 / 직접 해 보기(PowerShell·zsh) / 실수와 함정 / 점검 질문)을 따른다
- [ ] 변경에 따른 예상 월 비용을 PR에 적는다 (비용 변화가 없으면 "없음")

## 비고

코드 변경 없음. 결정의 판단은 사용자의 것이고 ADR은 api 레포에 사용자 답변을 근거로 따로 쓴다.

## 관련 문서

- HANDOFF: 1장 "인프라 구성", 2장 에이전트별 원칙 (infra)
- 지원하는 PRD AC: `AC-WS-06` `AC-MB-06` (방문자 IP 식별), `AC-WS-36` (배치 단일 인스턴스 전제)
- 관련 ADR: api 레포 `docs/adr/` (생기면 링크)
