cd "$(dirname "$0")"

# usage: mk_infra KEY "작업 내용" "완료 조건" "관련 AC" "선행" ["비고"]
mk_infra() {
  local note=""
  if [ -n "$6" ]; then note="
## 비고

$6
"; fi
  cat > "$1.md" <<EOT
## 작업 내용

$2

- Epic: 없음 (인프라 이슈는 Milestone만 연결한다)
- 선행: $5
- 권장 순서: {{IN0}} → {{IN1}} → {{IN3}} → {{IN2}} → {{IN4}} → {{IN5}} → {{IN6}} → {{IN7}}

## 완료 조건

$3
- [ ] 해당 **학습 가이드**(infra 레포 \`docs/learning/NNNN-주제.md\`)를 작성·갱신하고 \`docs/learning/README.md\` 목록에 추가한다. 내용은 \`.claude/agents/infra.md\` "학습 가이드" 절(개념 / 결정과 이유 / 실제 구성 읽기 / 직접 해 보기(PowerShell·zsh) / 실수와 함정 / 점검 질문)을 따른다
- [ ] 변경에 따른 예상 월 비용을 PR에 적는다 (비용 변화가 없으면 "없음")
$note
## 관련 문서

- HANDOFF: 1장 "인프라 구성", 2장 에이전트별 원칙 (infra)
- 지원하는 PRD AC: $4
- 관련 ADR: api 레포 \`docs/adr/\` (생기면 링크)
EOT
}

mk_infra IN0 "인프라 구성 결정(HANDOFF 1장 \"인프라 구성\")의 근거를 AWS·Terraform을 모르는 사용자가 이해하고 설명할 수 있게 학습 가이드로 쓴다. 코드 작업은 없다. 이후 모든 인프라 이슈의 첫 읽을 것이 된다.

다룰 내용:
- 선택한 구성: EC2 한 대(t4g.small, 서울 리전) + Docker Compose(web·api·DB) + Caddy(HTTPS 종료, \`/api/*\` → Spring, 나머지 → Next.js)
- 버린 대안과 이유: ECS Fargate + ALB + RDS (비용 약 3배, 학습 부담), Lightsail, RDS (컨테이너 DB + 일일 EBS 스냅샷 7일로 대체)
- 파일 위치 규칙: Dockerfile·짧은 CI 호출 워크플로는 각 앱 레포(api 레포 파일은 사용자가 커밋), 재사용 워크플로·운영/로컬 Compose·Caddyfile·Terraform은 infra 레포
- 이미지 저장소 GHCR(public), 이미지에 비밀값을 넣지 않는 이유
- 방문자 IP 전달: Caddy가 \`X-Forwarded-For\`를 실제 접속 IP로 다시 쓰고 Spring은 \`forward-headers-strategy=native\`로 내부 프록시만 신뢰. 보안 그룹 80·443만. 대여·가입 요청은 브라우저가 \`/api\`를 직접 호출
- 정리 배치는 앱 내 스케줄러(외부 트리거 없음)
- 월 비용 약 \$22의 산출 근거, 새 AWS 계정 생성·Paid plan·예산 알림(월 \$30)을 가장 먼저 만드는 이유
- 재검토 조건: 서버 한 대로 부족해지거나 무중단 배포가 필요해지면 ECS" \
"- [ ] \`docs/learning/0001-인프라-구성-결정.md\`(제목은 infra가 정함)에 위 내용이 모두 들어 있다
- [ ] 비용표: 선택 구성 vs ECS Fargate 구성의 월 비용 비교, 가정(리전·사용량·프리 티어 여부) 명시
- [ ] \`docs/learning/README.md\`에 목록과 권장 읽기 순서가 있다" \
"\`AC-WS-06\` \`AC-MB-06\` (방문자 IP 식별), \`AC-WS-36\` (배치 단일 인스턴스 전제)" "없음" "코드 변경 없음. 결정의 판단은 사용자의 것이고 ADR은 api 레포에 사용자 답변을 근거로 따로 쓴다."

mk_infra IN1 "로컬 개발용 Docker Compose(PostgreSQL)와 infra 레포 README를 만든다. 사용자(백엔드)와 frontend가 Windows·macOS 어디서든 \`docker compose up\` 한 번으로 DB를 띄울 수 있어야 한다.

- 로컬 Compose: PostgreSQL 컨테이너, 볼륨, 포트, 기본 DB·사용자. 비밀값은 \`.env.example\`로 예시만 두고 실제 값은 커밋하지 않는다
- README: 레포 구조도, 선택한 인프라 구조도(EC2+Compose+Caddy), 월 비용표, 자주 쓰는 명령(PowerShell·zsh 둘 다), 학습 가이드 목록 링크
- \`.gitattributes\`(\`* text=auto eol=lf\`)·\`.editorconfig\`가 없으면 함께 추가" \
"- [ ] Windows(PowerShell)와 macOS(zsh)에서 \`docker compose up\`으로 PostgreSQL이 기동되고 Spring 로컬 설정에서 접속할 수 있다
- [ ] 비밀값이 커밋되지 않는다 (\`.env.example\`만)
- [ ] README에 구조도·월 비용표·명령(두 OS)이 있다" \
"없음 (개발 환경)" "{{IN0}}"

mk_infra IN2 "web 레포의 Next.js Dockerfile을 작성하고, api 레포의 Spring Boot Dockerfile은 **제안**으로 api 레포에 이슈를 만든다 (infra는 api 레포에 쓰지 않는다).

- web: 멀티 스테이지 빌드, 비루트 실행, 이미지에 비밀값 없음. **Next.js 초기화({{F02}} 등 web 레포 첫 작업) 이후 착수**
- api 제안: JDK 빌드 → JRE 실행 멀티 스테이지, JVM 메모리 옵션(\`-XX:MaxRAMPercentage\`, t4g.small 2GB에서 web·DB와 공존), 비루트 실행, actuator health용 포트. api 레포에 \`[BE]\` Task 이슈로 생성하고 본문에 Dockerfile 제안 전문을 넣는다" \
"- [ ] web 레포에 Dockerfile이 커밋되고 로컬에서 \`docker build\`·실행이 된다 (두 OS)
- [ ] api 레포에 Dockerfile 제안 이슈가 생성되어 있다 (링크를 이 이슈에 남긴다)
- [ ] 이미지 크기와 빌드 시간을 PR에 적는다" \
"없음" "{{IN1}}; web은 Next.js 초기화 이후"

mk_infra IN3 "GitHub Actions **재사용 워크플로**(\`workflow_call\`)를 infra 레포에 두고, 각 앱 레포에는 짧은 호출 워크플로만 둔다.

- web: lint · build · test. web 레포의 호출 워크플로는 infra가 직접 커밋
- api: \`gradle test\` (Java 21, Gradle 캐시). api 레포의 호출 워크플로는 **제안**으로 api 레포에 \`[BE]\` Task 이슈를 만든다 (본문에 워크플로 전문)
- PR과 main 푸시에서 실행. 캐시로 반복 실행 시간을 줄인다" \
"- [ ] infra 레포에 web·api용 재사용 워크플로가 있고, web 레포 PR에서 lint·build·test가 돈다
- [ ] api 레포에 호출 워크플로 제안 이슈가 생성되어 있다 (링크를 이 이슈에 남긴다)
- [ ] 워크플로가 Windows·macOS 로컬 명령과 같은 명령을 쓴다 (한쪽 OS 전용 스크립트 없음)" \
"없음" "{{IN1}}"

mk_infra IN4 "Terraform 기반을 만든다: 원격 state(S3 버킷 + 잠금), GitHub Actions가 키 없이 AWS에 접근하는 OIDC 역할, 월 \$30 예산 알림.

- 새 AWS 계정은 사용자가 만든다 (Paid plan). 예산 알림을 **가장 먼저** 만든다
- \`terraform plan\` 결과를 사용자에게 설명하고 **승인 뒤에만 apply**한다 (infra는 직접 실행하지 않는다)
- 비밀값·계정 ID는 코드에 하드코딩하지 않는다" \
"- [ ] 원격 state(S3)가 동작하고 로컬 두 OS에서 \`terraform init\`·\`plan\`이 된다
- [ ] GitHub OIDC 역할로 infra 레포 워크플로가 키 없이 AWS에 인증한다 (최소 권한)
- [ ] 월 \$30 예산 알림이 사용자 이메일로 동작함을 확인했다 (테스트 알림 또는 콘솔 확인)
- [ ] plan 설명 → 사용자 승인 → apply 절차가 PR·이슈 코멘트에 남아 있다" \
"없음" "{{IN0}}; 사용자: AWS 계정 생성"

mk_infra IN5 "운영 서버를 Terraform으로 만든다: VPC·서브넷, 보안 그룹(인바운드 80·443만), EC2 t4g.small(서울), 고정 IP(Elastic IP), SSM으로 접속(SSH 포트 없음), 매일 EBS 스냅샷 7일 보관(DLM). NAT Gateway는 두지 않는다(비용).

- 각 리소스가 무엇이고 왜 필요한지 한 줄 설명을 코드 주석과 학습 가이드에 둔다
- plan 설명 후 사용자 승인 뒤 apply" \
"- [ ] SSH 포트를 열지 않고 SSM Session Manager로 접속된다 (두 OS 명령 제시)
- [ ] 보안 그룹 인바운드는 80·443만이다
- [ ] 일일 스냅샷이 생성되고 7일 뒤 삭제되는 정책이 적용되어 있다
- [ ] NAT Gateway가 없다. 예상 월 비용(EC2·EBS·EIP·스냅샷)이 PR과 README 비용표에 표시된다" \
"\`AC-WS-06\` \`AC-MB-06\` (80·443만 열어 프록시 경유 보장)" "{{IN4}}"

mk_infra IN6 "운영용 Docker Compose(web·api·PostgreSQL·Caddy)와 Caddyfile을 만든다. Caddy가 HTTPS(자동 인증서)와 경로 라우팅(\`/api/*\` → Spring, 나머지 → Next.js)을 맡고 방문자 IP를 전달한다.

- **방문자 IP**: Caddy가 \`X-Forwarded-For\`를 실제 접속 IP로 다시 써서 클라이언트가 보낸 위조 값을 무시한다. Spring 쪽 설정(\`server.forward-headers-strategy=native\`), actuator health, graceful shutdown, DB 접속 환경변수는 **api 레포 \`[BE]\` Task 이슈로 제안**한다
- 테스트 계정 대여(\`AC-WS-06\`)·회원가입(\`AC-MB-06\`) 요청은 브라우저가 \`/api\`를 직접 호출하므로 같은 도메인 라우팅이면 CORS가 필요 없음을 확인한다
- 비밀값은 서버의 \`.env\`로만 두고 커밋하지 않는다. DB 데이터는 볼륨
- **도메인 구매는 사용자가 한다** (DNS A 레코드를 고정 IP로)" \
"- [ ] HTTPS로 접속되고 \`/api/*\`는 Spring, 나머지는 Next.js로 라우팅된다
- [ ] 위조 \`X-Forwarded-For\`를 넣어 요청해도 Spring이 실제 접속 IP를 보는 것을 검증했다 (검증 절차를 가이드에)
- [ ] api 레포에 Spring 설정 제안 이슈(forward-headers·health·graceful shutdown·DB 환경변수)가 생성되어 있다
- [ ] 컨테이너 재시작 정책과 health check가 있어 api가 죽으면 다시 뜬다" \
"\`AC-WS-06\` \`AC-MB-06\` (방문자 IP 식별), \`AC-WS-36\` (api 인스턴스 하나)" "{{IN2}}, {{IN5}}; 사용자: 도메인 구매"

mk_infra IN7 "CD: web·api 레포 main 머지 시 이미지를 GHCR에 푸시(태그: 커밋 SHA + latest)하고, SSM Run Command로 EC2에서 \`docker compose pull && up\`을 실행한다. 태그를 지정해 이전 이미지로 되돌리는 롤백 절차를 문서화한다.

- api 레포 워크플로는 제안·이슈로 전달한다 (infra는 api 레포에 쓰지 않는다)
- OIDC 역할({{IN4}})로 인증, 장기 키 없음
- 무중단 배포는 범위 밖 (재검토 조건은 HANDOFF 1장)" \
"- [ ] web 레포 main 머지 → GHCR 푸시 → EC2 배포가 자동으로 된다. api는 제안 이슈가 생성되어 있다
- [ ] 특정 태그로 롤백하는 절차(두 OS 명령)가 학습 가이드에 있고 한 번 실제로 수행해 확인했다
- [ ] 배포 실패 시 알 수 있다 (워크플로 실패 알림)
- [ ] 이미지에 비밀값이 없다" \
"없음" "{{IN3}}, {{IN6}}"

ls IN*.md | wc -l
