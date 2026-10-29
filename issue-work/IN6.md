## 작업 내용

운영용 Docker Compose(web·api·PostgreSQL·Caddy)와 Caddyfile을 만든다. Caddy가 HTTPS(자동 인증서)와 경로 라우팅(`/api/*` → Spring, 나머지 → Next.js)을 맡고 방문자 IP를 전달한다.

- **방문자 IP**: Caddy가 `X-Forwarded-For`를 실제 접속 IP로 다시 써서 클라이언트가 보낸 위조 값을 무시한다. Spring 쪽 설정(`server.forward-headers-strategy=native`), actuator health, graceful shutdown, DB 접속 환경변수는 **api 레포 `[BE]` Task 이슈로 제안**한다
- 테스트 계정 대여(`AC-WS-06`)·회원가입(`AC-MB-06`) 요청은 브라우저가 `/api`를 직접 호출하므로 같은 도메인 라우팅이면 CORS가 필요 없음을 확인한다
- 비밀값은 서버의 `.env`로만 두고 커밋하지 않는다. DB 데이터는 볼륨
- **도메인 구매는 사용자가 한다** (DNS A 레코드를 고정 IP로)

- Epic: 없음 (인프라 이슈는 Milestone만 연결한다)
- 선행: {{IN2}}, {{IN5}}; 사용자: 도메인 구매
- 권장 순서: {{IN0}} → {{IN1}} → {{IN3}} → {{IN2}} → {{IN4}} → {{IN5}} → {{IN6}} → {{IN7}}

## 완료 조건

- [ ] HTTPS로 접속되고 `/api/*`는 Spring, 나머지는 Next.js로 라우팅된다
- [ ] 위조 `X-Forwarded-For`를 넣어 요청해도 Spring이 실제 접속 IP를 보는 것을 검증했다 (검증 절차를 가이드에)
- [ ] api 레포에 Spring 설정 제안 이슈(forward-headers·health·graceful shutdown·DB 환경변수)가 생성되어 있다
- [ ] 컨테이너 재시작 정책과 health check가 있어 api가 죽으면 다시 뜬다
- [ ] 해당 **학습 가이드**(infra 레포 `docs/learning/NNNN-주제.md`)를 작성·갱신하고 `docs/learning/README.md` 목록에 추가한다. 내용은 `.claude/agents/infra.md` "학습 가이드" 절(개념 / 결정과 이유 / 실제 구성 읽기 / 직접 해 보기(PowerShell·zsh) / 실수와 함정 / 점검 질문)을 따른다
- [ ] 변경에 따른 예상 월 비용을 PR에 적는다 (비용 변화가 없으면 "없음")

## 관련 문서

- HANDOFF: 1장 "인프라 구성", 2장 에이전트별 원칙 (infra)
- 지원하는 PRD AC: `AC-WS-06` `AC-MB-06` (방문자 IP 식별), `AC-WS-36` (api 인스턴스 하나)
- 관련 ADR: api 레포 `docs/adr/` (생기면 링크)
