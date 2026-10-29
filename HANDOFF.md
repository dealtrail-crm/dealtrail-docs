# 프로젝트 인수인계: AI 에이전트 협업 포트폴리오 프로젝트

> 이 문서는 claude.ai에서 논의해 확정한 **결정 사항**입니다.
> 에이전트 정의 파일, 템플릿, CLAUDE.md 등 실제 파일은 이 문서를 근거로 작성합니다.
> 이 문서에 없는 내용은 추측하지 말고 사용자에게 질문합니다.

---

## 0. 프로젝트 개요

- **목적**: 포트폴리오. 평가 대상은 사용자의 **백엔드 역량과 기술적 의사결정·문제 해결 능력**.
- **형태**: Claude Code 서브에이전트(PM, 디자이너, 프론트엔드, 인프라, 시니어 백엔드 리뷰어)와 협업. 사용자는 백엔드 개발 담당.
- **도메인**: 범용 B2B 영업 CRM (미니 CRM). 아래 "도메인 상세" 참고
- **프로젝트명**: `dealtrail` (deal + trail, 영업 건이 단계를 거쳐 남긴 이력).
- **에이전트 산출물 범위**: 문서뿐 아니라 실제 코드까지 작성
- **핵심 원칙**: 기술적 화려함보다 **방문자가 사이트에 들어오자마자 직접 써볼 수 있는 것**

### 도메인 상세: 미니 CRM

**선정 배경**: 사용자가 CRM 직무에 지원하면서 CRM 도메인을 이해하기 위해, Salesforce 같은 CRM 서비스의 핵심 개념만 추려 직접 구현한다. Salesforce 플랫폼 경험을 대체하려는 목적은 아니다.

**핵심 개념**

| 개념 | 의미 |
|---|---|
| Lead | 아직 검증되지 않은 잠재 고객 |
| Account | 거래 대상 회사 |
| Contact | Account에 속한 담당자 |
| Opportunity | 진행 중인 영업 건 (금액, 단계, 예상 마감일) |
| Activity | 통화·미팅·할 일 기록 |

대표 흐름: Lead를 검증하면 Account + Contact + Opportunity로 **전환(Convert)**되고, Opportunity가 단계(예: 발굴 → 제안 → 협상 → 수주/실패)를 거쳐 진행된다.

**MVP 범위**

| 포함 | 제외 |
|---|---|
| Lead 등록·검증·전환 (Account·Contact·Opportunity 동시 생성) | 노코드 화면·필드 커스터마이징 |
| Account / Contact 관리 | 자동화 엔진 (Flow 류) |
| Opportunity 단계 관리 + 파이프라인 칸반 | 이메일·캘린더 연동 |
| 활동 기록 (통화, 미팅, 할 일) | 견적·계약서 생성 |
| 대시보드 (단계별 금액, 수주율) | 다중 조직·복잡한 권한 계층 |

**체험 방식 (즉시 사용성 확보)**
- 방문자는 개인정보 없이 **테스트 계정**으로 바로 체험한다. 미리 둔 테스트 계정(기본 5개) 중 빈 계정에 비밀번호를 정해 24시간(기본값, 설정값) 동안 독점으로 빌린다. 같은 IP는 동시에 1개만 빌릴 수 있다.
- 대여 후 **업종을 선택**하면 그 업종의 예시 데이터가 들어 있는 전용 작업 공간이 생긴다. 초기화 버튼으로 데이터를 지우고 업종을 다시 고를 수 있다.
- 대여 시간이 지나면 비밀번호와 데이터를 지우고 계정을 반납한다. 정리 주기도 설정값이다 (`prd/99-decisions-tbd.md` TBD-26).
- 며칠에 걸쳐 써 보려는 사람을 위해 아이디·비밀번호만으로 하는 **일반 회원가입**도 둔다 (소셜 로그인 없음).
- 인증은 핵심이 아니므로 단순하게 둔다. 로그인은 브라우저를 닫아도 유지된다.
- 세부 규칙은 `prd/01-trial-workspace.md`.
- 체험 업종: 제조, IT·소프트웨어, 전문 서비스 3개에 예시 데이터를 둔다. 업종 선택 화면에는 업종 목록 15개를 모두 보여 주고 나머지는 "준비 중"으로 둔다. 목록과 예시 데이터 구성은 `prd/00-overview.md` §4.1, `prd/01-trial-workspace.md` §3.2.1.

**백엔드 설명 포인트 (ADR·트러블슈팅 소재 후보)**
- Lead 전환: 여러 엔티티를 한 트랜잭션으로 생성, 중간 실패 시 전체 롤백
- Opportunity 단계 전이: 허용된 단계로만 이동하는 상태 머신 + 변경 이력
- 작업 공간 간 데이터 격리, 업종별 시드 데이터 생성, 만료 대여 정리 배치
- 테스트 계정 동시 대여 경쟁(한 명만 성공)
- 파이프라인 집계 (단계별 금액 합계, 수주율)

**주의**: 서비스 이름·로고·화면은 Salesforce를 따라 하지 않는다. 개념만 참고한 자체 서비스로 만든다.

## 1. 기술 스택

| 영역 | 기술 |
|---|---|
| 프론트엔드 | Next.js |
| 백엔드 | Java Spring (필요 시 NestJS 사용 가능). **Spring Boot 4.1.2 / Java 21 / Gradle**. group `com.dealtrail`, 패키지 `com.dealtrail.api` |
| DB | PostgreSQL |
| 배포 | AWS 서울 리전(`ap-northeast-2`). **EC2 한 대(t4g.small) + Docker Compose + Caddy**. EKS·ECS·쿠버네티스 사용 안 함 |

### 인프라 구성

- 이 프로젝트에서 사용자는 **AWS와 Terraform을 잘 모르는 사람**으로 가정한다. 어려운 기술은 쓰지 않는다.
- **배포**: EC2 한 대에 Docker Compose로 web·api·DB를 띄우고, Caddy가 HTTPS 종료와 경로 라우팅(`/api/*` → Spring, 나머지 → Next.js)을 맡는다. 예상 월 비용 약 $22 (ECS Fargate + ALB + RDS 구성의 약 1/3).
- **DB**: 같은 EC2 안의 PostgreSQL 컨테이너 + 매일 EBS 스냅샷 7일 보관. RDS는 쓰지 않는다.
- **파일 위치**: Dockerfile과 짧은 CI 호출 워크플로는 각 앱 레포(api 레포 파일은 사용자가 커밋), 재사용 워크플로·운영/로컬 Compose·Caddyfile·Terraform은 infra 레포.
- **이미지 저장소**: GHCR (public). 이미지에 비밀값을 넣지 않는다.
- **Terraform state**: S3 원격 state + S3 잠금. 두 기기(Windows·macOS)가 같은 state를 쓴다.
- **CI/CD 인증**: GitHub Actions는 OIDC 역할로 AWS에 인증한다. 장기 접근 키를 두지 않는다.
- **배포 실행**: SSM Run Command로 EC2에서 `docker compose pull && up`을 실행한다. SSH(22)는 열지 않는다. 워크플로는 명령 결과를 기다려 실패를 감지한다.
- **고정 IP**: Elastic IP. 도메인이 가리키는 IP가 인스턴스 재시작에도 바뀌지 않게 한다.
- **롤백**: 이미지 태그는 커밋 SHA(+ `latest`). 이전 SHA 태그로 다시 띄워 되돌린다. DB 스키마는 이미지 롤백으로 되돌아가지 않는다.
- **방문자 IP**: Caddy가 실제 접속 IP로 `X-Forwarded-For`를 다시 쓰고, Spring은 `server.forward-headers-strategy=native`로 내부 프록시만 신뢰한다. 보안 그룹은 80·443만 연다. 테스트 계정 대여·회원가입 요청은 브라우저가 `/api`를 직접 호출한다 (Next.js 서버 경유 시 방문자 IP를 잃음).
- **정리 배치**: 앱 안 스케줄러(Spring `@Scheduled`). 외부 트리거를 두지 않는다.
- **도메인**: 새로 구매. **AWS 계정**: 새로 생성, Paid plan + 예산 알림(월 $30)을 가장 먼저 만든다.
- 재검토 조건: 서버 한 대로 부족해지거나 무중단 배포가 필요해지면 ECS로 옮긴다.

## 2. 에이전트 구성과 역할

메인 Claude가 작업을 보고 적절한 에이전트에게 **분배**한다.

| 에이전트 | 역할 | 주요 산출물 위치 |
|---|---|---|
| **pm** | 요구사항(PRD), 유저 스토리, 인수조건 작성. GitHub MCP로 Epic·작업 이슈 생성. 코드 작성 안 함 | docs 레포 `prd/`, 각 레포 이슈 |
| **designer** | 화면 흐름, 컴포넌트 스펙, 디자인 토큰. 토큰은 프론트가 바로 쓸 수 있는 형태(예: Tailwind 설정)로 제공 | docs 레포 `design/` |
| **frontend** | Next.js 구현. API 계약만 기준으로 구현하고, 계약에 없는 API는 직접 만들지 않고 요청 | web 레포 |
| **infra** | Terraform, Dockerfile, CI/CD. 아래 원칙 준수 | infra 레포 |
| **senior-backend** | (1) API 계약 문서 작성 (2) 사용자의 백엔드 PR 리뷰 | docs 레포 `api/`, api 레포 PR 코멘트 |

### 모델 배정

| 대상 | 모델 | 설정 위치 |
|---|---|---|
| 메인 세션 (작업 배분, ADR 작성 보조) | **opus** | docs 레포 `.claude/settings.json`의 `"model": "opus"` |
| pm | **fable** | `.claude/agents/pm.md` frontmatter `model: fable` |
| senior-backend | **fable** | `.claude/agents/senior-backend.md` frontmatter `model: fable` |
| designer / frontend / infra | **opus** | 각 정의 파일 frontmatter `model: opus` |

- 기준: 기획·의사결정 비중이 큰 역할은 Fable, 나머지는 Opus.
- 메인 세션에서 중요한 결정 논의가 필요하면 `/model fable`로 잠시 전환할 수 있다 (`s`로 현재 세션에만 적용).
- Fable 5.1은 Claude Code **v2.1.257 이상** 필요. 시작 전 `claude --version` 확인, 낮으면 `claude update`.
- 요금제에 따라 Fable 사용량이 추가 사용 크레딧으로 청구될 수 있다. `claude -p`(비대화형)는 동의 없이 청구되므로 주의.

### 에이전트별 원칙

- **infra**
  - "AWS·Terraform을 모르는 사람"에게 설명하는 톤이 기본.
  - 변경마다 예상 비용을 함께 제시.
  - `terraform apply` 등 실제 리소스를 생성·변경하는 명령은 직접 실행하지 않고 사용자의 승인을 받는다.
  - 사용자가 인프라를 학습할 수 있도록 결정과 작업마다 **학습 가이드**를 infra 레포 `docs/learning/`에 작성한다.
- **senior-backend (리뷰)**
  - 관점: 코드 가독성, 유지보수성, 동시성 문제, 트랜잭션, 배포 영향 등 시니어가 주니어에게 해줄 수 있는 조언.
  - 필요하면 코드 개선 제안까지 한다.
  - 리뷰는 **GitHub PR 코멘트**로 남긴다 (포트폴리오에서 리뷰 이력이 보이도록).
- **senior-backend (API 계약)**
  - PRD와 디자인 스펙을 보고 프론트-백엔드 계약 문서를 작성한다.
  - 자기 리뷰 문제를 상쇄하기 위해 **frontend가 소비자 관점에서 계약을 검토**하고("이 계약으로 화면을 다 만들 수 있는가"), **사용자가 최종 승인**한다.
  - 산출물 두 가지:
    - `api/*.md`: 사용자가 읽고 구현할 문서. API별 목적, 요청/응답, 비즈니스 규칙, 에러 케이스, 동시성 주의점.
    - `api/openapi.yaml`: 프론트의 타입 생성·목(mock)용. 사용자가 직접 작성하지 않는다.
  - 추후 Spring springdoc으로 생성한 스펙과 비교해 구현이 계약대로 됐는지 검증하는 방안도 고려.

### 백엔드 코드 접근 규칙

- api 레포의 git은 **사용자가 직접 관리**한다. 에이전트는 api 레포에 커밋하지 않는다.
- senior-backend: 읽기 + PR 코멘트. 사용자가 요청하면 구현 중인 코드에 대해 개선 코드를 작성할 수 있다 (커밋은 사용자가 한다).
- 도구 권한: pm·senior-backend 모두 Edit/Write를 열어 둔다. "pm은 코드를 작성하지 않는다"는 에이전트 정의 파일의 정책으로만 둔다.
- frontend: 백엔드에 문제가 있을 때만 api 코드에 접근할 수 있고, **코드를 수정하지 않고 원인을 분석해 이슈만 생성**한다.
- 그 외 에이전트는 api 레포에 접근하지 않는다.

## 3. 레포 구성

GitHub **Organization** `dealtrail-crm`(무료)에 아래 레포를 둔다.

```
Organization
├─ .github             ← 조직 소개 README(profile/README.md) + 공용 이슈/PR 템플릿
├─ {프로젝트명}-docs     ← PRD, 디자인, API 계약, .claude/agents, CLAUDE.md, Epic 이슈
├─ {프로젝트명}-api      ← 사용자 (Spring) + ADR/트러블슈팅 기록
├─ {프로젝트명}-web      ← frontend 에이전트
└─ {프로젝트명}-infra    ← infra 에이전트
```

### 레포를 분리한 이유 (첫 번째 ADR 소재)

- **기여 범위의 명확성**: api 레포는 사용자가 직접 설계·구현·커밋한 코드, 나머지는 AI 에이전트와 협업해 생성한 코드임을 레포 단위로 구분한다. 모노레포는 커밋이 섞여 본인 작업 범위가 불분명해진다.
- **실무 구조 반영**: 백엔드·프론트·인프라가 배포 주기와 소유권을 따로 갖는 팀 구조.
- **경계의 기술적 강제**: "에이전트는 백엔드를 커밋하지 않는다"를 규칙이 아니라 레포 경계로 보장.
- docs·에이전트 설정·이슈를 infra에 넣지 않은 이유: 레포 목적이 흐려지고, 문서 변경에도 인프라 CI가 반응하는 문제.

### `.github` 레포 용도

- `profile/README.md`: Organization 첫 화면. 프로젝트 소개, 아키텍처 그림, 레포별 역할, **AI 협업 범위** 명시.
- 공용 이슈/PR 템플릿: 자체 템플릿이 없는 모든 레포에 기본 적용.

### 로컬 구성과 실행

```
workspace/
├─ {프로젝트명}-docs/    ← 여기서 Claude Code 실행
├─ {프로젝트명}-api/
├─ {프로젝트명}-web/
└─ {프로젝트명}-infra/
```

Windows (PowerShell)

```powershell
cd workspace\{프로젝트명}-docs
claude --add-dir ..\{프로젝트명}-api ..\{프로젝트명}-web ..\{프로젝트명}-infra
```

macOS (zsh)

```bash
cd workspace/{프로젝트명}-docs
claude --add-dir ../{프로젝트명}-api ../{프로젝트명}-web ../{프로젝트명}-infra
```

- 에이전트 커밋 권한: docs / web / infra / .github 만. `.github` 레포(공용 이슈·PR 템플릿)는 pm이 작성·커밋.
- api 레포의 ADR·트러블슈팅 **템플릿**(틀)은 senior-backend가 초안을 만들고 사용자가 검토·커밋한다. 기록 본문은 6장의 문답 방식을 따른다.
- 에이전트 커밋·PR에 `Co-Authored-By` 꼬리말이나 AI 작성 문구를 붙이지 않는다. docs 레포 `.claude/settings.json`의 `"attribution": false`로 끈다 (Claude Code v2.1.281 이상 필요).
- 브랜치 보호는 걸지 않는다. 작업자가 사용자 한 명뿐이고 실제 프로덕트가 아니므로 PR 머지는 규칙으로만 지킨다.

## 4. 이슈 기반 프로젝트 관리

### 구조

- **Milestone**: 출시 단위 (예: `v0.1 MVP`)
- **Epic 이슈**: **구현 순서 단위**. 앞선 Epic에만 의존하고, 끝나면 화면에서 직접 써볼 수 있는 결과가 나오게 자른다. PRD 기능 하나가 여러 Epic에 걸칠 수 있다(01 → Epic 1·6). **docs 레포**에 생성. PM이 생성. 제목은 `[Epic N] 제목`.
- **작업 이슈**: 코드가 바뀌는 레포에 생성. `[FE]` → web, `[BE]` → api, `[INFRA]` → infra, `[DOCS]` → docs(API 계약 등 문서 작업).
- **Issue type** (org 단위 GitHub Issue types): `Epic` / `Feature` / `Bug` / `Task`
  - chore·문서 작업은 `Task`로 묶는다. `Epic`은 docs 레포의 Epic 이슈에만 쓴다.
  - 종류를 라벨(`type:*`)로 표시하지 않는다.
- **Label**
  - 영역: `area:web` / `area:api` / `area:infra` / `area:design` / `area:docs`(API 계약·PRD·디자인 문서 등 문서 작업)
  - 우선순위: `priority:high` / `priority:medium` / `priority:low`. PM이 정하고, 조정이 필요하면 사용자가 PM에게 요청한다.
  - 라벨은 레포 단위라 docs·api·web·infra 4개 레포에 같은 세트를 만든다.
- **조직 단위 GitHub Projects 보드** 하나로 전 레포 이슈를 칸반(할 일 / 진행 중 / 리뷰 중 / 완료)으로 본다.

### v0.1 MVP Epic (구현 순서)

Epic 1~5 동안은 예시 데이터 없이 직접 입력해서 확인한다.

| Epic | 제목 | Epic 이슈 | PRD | 끝나면 할 수 있는 것 |
|---|---|---|---|---|
| 1 | 체험 계정과 로그인 | docs#1 | 01 (대여·세션·빈 작업 공간 생성), 00 §6 | 체험하기 → 비밀번호 → 업종 선택 → 빈 작업 공간, 남은 시간·만료 안내 |
| 2 | Account / Contact | docs#3 | 03 | 거래처·담당자 CRUD, 재직 상태 |
| 3 | Opportunity와 파이프라인 | docs#4 | 04, 03의 Opportunity 연결 부분 | 칸반이 기본 화면, 단계 이동·거부·이력, 종료 잠금 |
| 4 | Lead 등록·전환 | docs#2 | 02 | Lead 등록·상태 변경·전환(새/기존 Account) |
| 5 | 활동 기록 | docs#5 | 05, 02·03·04의 활동 부분 | 상세 4곳 활동 기록, 모아 보기, 통합 타임라인, 전환 시 활동 이동, 삭제 시 활동 함께 삭제 |
| 6 | 예시 데이터·초기화·정리 | docs#16 | 01 (적재·초기화·격리 검증·정리 배치), seed | 업종 고르면 예시 데이터 가득, 초기화로 업종 재선택, 만료 → 정리 |
| 7 | 대시보드 | docs#6 | 06 | 집계·수주율·할 일 위젯, 초기화 버튼 대시보드 배치 |
| 8 | 회원 계정 | docs#7 | 07 | 가입·로그인, 만료 없이 같은 흐름 |

- 초기화 FE는 Epic 6에서 흐름을 만들고(진입점은 임시로 앱 셸) Epic 7에서 대시보드에 배치한다. 작업 공간 생성 뒤 이동 목적지는 Epic 3에서 파이프라인으로 확정한다.
- 인프라 이슈 착수: infra#1·#2는 Epic 1 착수 전, infra#4·#3은 Epic 1 중, infra#5는 AWS 계정 생성 직후(늦어도 Epic 3 종료 전), infra#6~#8은 Epic 3 종료 후(첫 배포). 각 이슈 본문 "착수 시점" 참조.

### 흐름

```
PM: PRD 작성 → Epic + 작업 이슈 생성 (각 이슈에 인수조건 포함)
  ↓
메인 Claude: area 라벨을 보고 담당 에이전트에게 배분
  ↓
에이전트: 브랜치 생성 → 구현 → PR 생성 ("Closes #번호")
  ↓
리뷰 → 머지 → 이슈 자동 종료 → Epic 진행률 갱신
```

- 백엔드 이슈(`area:api`)는 사용자가 직접 가져가 같은 규칙으로 브랜치·PR을 만들고, senior-backend가 PR 코멘트로 리뷰한다.

### 작업 이슈 작성 규칙

- **분할**: AC 2~4개당 이슈 하나. 화면·기능 경계상 예외가 필요하면 이유를 이슈 본문 "비고"에 적는다. 같은 PR로 끝나는 이슈가 많아 부담되면 사용자 요청 시 PM이 합친다.
- **설명 포인트**: 이슈 하나에 설명 포인트 두 개를 섞지 않는다. 포인트별 "핵심 이슈" 하나를 정해 Epic 본문에 표시하고, ADR·트러블슈팅은 그 이슈를 가리킨다. 핵심 이슈 본문에는 "구현 시 결정할 것"을 둔다.
- **AC 인용**: 이슈 본문에 AC ID를 그대로 인용하고 PRD 원문은 링크로 대신한다. `[공통]` AC는 FE·BE 양쪽 이슈에 같은 ID를 인용하고 줄 끝 괄호에 담당 부분을 적는다. 엔티티별 격리 AC는 격리 교차 검증 이슈에만 인용한다.
- **선행 관계**: 이슈 본문에 선행 이슈 번호를 적는다. 선행은 **같은 Epic 또는 앞선 Epic**의 이슈만 가리킨다. 뒤 Epic이 필요한 AC는 그 Epic의 이슈로 옮기고, 원 이슈에는 "(…부분은 Epic N의 이슈)"로 표시한다.
- **이슈 참조 형식**: 이슈 참조(`dealtrail-crm/dealtrail-web#6`)를 둘 이상 나열할 때는 **한 줄에 하나씩** 불릿으로 쓴다. 범위 표기(`#14~#18`)를 쓰지 않는다. 참조에 붙는 설명은 상위 항목 줄이나 각 불릿 뒤에 둔다. "선행"·"설명 포인트"·Epic 본문의 하위 이슈·계약 목록 등 참조가 이어지는 모든 곳에 적용한다 (GitHub가 줄 안의 참조를 제목 링크로 렌더링해 여러 개가 이어지면 읽기 어렵다).
- **라벨**: Epic에는 하위 작업 이슈가 있는 영역의 area 라벨을 모두 붙인다. 작업 이슈의 priority는 Epic과 다를 수 있다(다른 Epic의 선행이면 올린다).
- **인프라 이슈**: Epic 없이 Milestone에만 연결한다. 본문 "관련 문서"에 HANDOFF 절·관련 AC ID·ADR 링크를 넣고, 완료 조건에 학습 가이드(infra 레포 `docs/learning/`) 작성을 넣는다.
- **API 계약 이슈**: docs 레포 `[DOCS]` Task, `area:docs`. 공통 규약 1개(docs#8, Epic 없음) + Epic별 계약(해당 Epic의 sub-issue). 작성 순서: 공통 → Epic 1(docs#9) → 2(docs#11) → 3(docs#12) → 4(docs#10) → 5(docs#13) → 6(docs#17) → 7(docs#14) → 8(docs#15). Epic 6 계약은 Epic 1 계약 문서(`api/01-trial-workspace.md`)를 확장한다.

### 이슈 생성 도구

- `gh issue create --repo … --title --body-file --label --milestone --type <Epic|Feature|Task> --project "Dealtrail Issue Tracker"`
  - Project 쪽 자동 추가와 `--project`가 겹치면 "Content already exists in this project" 오류로 gh가 type 지정 전에 멈출 수 있다. 생성 뒤 type·project를 따로 검증·보정한다 (type: `gh api graphql` `updateIssue(issueTypeId)` 또는 MCP `issue_write`, project: `gh project item-add`).
- 레포 간 sub-issue 연결 가능: `gh api -X POST repos/dealtrail-crm/<Epic 레포>/issues/<Epic번호>/sub_issues -F sub_issue_id=<하위 이슈의 .id>`. Epic 본문 체크리스트는 보조로 둔다.
- GitHub MCP에는 Projects 도구가 없다. 보드 조작은 gh로 한다.

### 설명 포인트별 핵심 이슈

| 설명 포인트 | 핵심 이슈 (Epic) | 관련 이슈 (Epic) |
|---|---|---|
| 테스트 계정 동시 대여 경쟁 | dealtrail-api#4 (1) | api#3 (1), api#5 (1) |
| 작업 공간 생성·시드 | dealtrail-api#8 (6) | api#7 (1, 빈 생성), api#9 (6) |
| 작업 공간 격리 | dealtrail-api#11 (1) | api#12 (6, 교차 검증) |
| 만료 대여 정리 배치 | dealtrail-api#13 (6) | api#6 (1, 만료 판정) |
| Lead 전환 트랜잭션 | dealtrail-api#16 (4) | api#17 (4), api#18 (5, 활동 이동 합류) |
| 단계 상태 머신 + 이력 | dealtrail-api#26 (3) | api#27 (3) |
| 파이프라인 집계 | dealtrail-api#33 (7) | api#28 (3), api#34 (7) |

## 5. Git 규칙

### 브랜치 전략: GitHub Flow

- `main`은 항상 배포 가능한 상태. 직접 푸시 금지, PR로만 머지 (브랜치 보호 없이 규칙으로 지킴).
- 작업 브랜치: `{type}/{이슈번호}-{요약}` (예: `feat/12-login-form`, `fix/31-token-refresh`)
- **Squash merge** (이슈 하나 = main 커밋 하나)
- Git Flow를 쓰지 않은 이유: 1인 사이드 프로젝트에 develop/release/hotfix 브랜치는 과함.

### 커밋 컨벤션: Conventional Commits

```
<type>(<scope>): <제목> (#이슈번호)

feat(web): 로그인 폼 유효성 검사 추가 (#12)
fix(api): 동시 주문 시 재고 음수 문제 수정 (#31)
```

- type: `feat` `fix` `refactor` `docs` `test` `chore` `ci` `build` `style`
- scope: `web` `api` `infra` `docs` `design`
- 제목은 한국어 허용, 50자 이내, 마침표 없음.

### 템플릿

- **커밋 템플릿** `.gitmessage`: **api 레포 루트**에만 둔다 (편집기로 커밋하는 건 사용자뿐, 에이전트는 `-m`이라 템플릿 미사용). 제목 형식·type 목록·본문(무엇을, 왜)·`Closes #`만 `#` 주석으로 둔 간소화 버전. 적용: 기기마다 api 레포에서 `git config commit.template .gitmessage` (전역 설정 아님)
- **PR 템플릿**: 관련 이슈(Closes #) / 변경 내용 / 확인 방법 체크리스트 / 리뷰어에게(특히 봐줬으면 하는 부분)
- **이슈 템플릿**
  - feature: 배경, 유저 스토리, 인수조건 체크리스트, 관련 문서 링크(PRD·디자인·API)
  - bug: 현상, 재현 절차, 기대 동작, 환경
  - task: 작업 내용, 완료 조건 (chore·인프라·문서용)
- 이슈/PR 템플릿은 `.github` 레포에 두어 전 레포에 공용 적용. Markdown 템플릿 + frontmatter `type:`으로 Issue type 자동 지정 (실제 동작은 PM 첫 이슈에서 확인). 빈 이슈 막기(`config.yml`)는 하지 않음.

## 6. 기술 결정·문제 해결 기록

문제 해결 사고력의 근거를 남기기 위한 기록. **api 레포**에 둔다 (인프라 결정이라도 "에이전트 제안 중 이 이유로 골랐다"는 판단은 사용자의 것이고, 평가받는 곳에 모여 있어야 함).

### (1) ADR: `docs/adr/0001-제목.md`

- 작성 기준: 되돌리는 비용이 크거나, 대안을 실제로 2개 이상 검토한 결정.
- 양식: **최상단 결론 요약(목적·원인 → 결정)** / 상태·날짜·관련 이슈·관련 PR / 맥락 / 검토한 대안(장단점 표) / 결정과 결정적 이유 / 결과와 트레이드오프(재검토 조건 포함)
- 상태 값: `제안됨` / `승인됨` / `대체됨 (→ NNNN)` / `폐기됨`. 뒤집힌 ADR은 고치지 않고 새 ADR을 쓴 뒤 기존 것을 `대체됨`으로 바꾼다.

### (2) 트러블슈팅: `docs/troubleshooting/0001-제목.md`

- 핵심은 **실패한 가설까지 포함한 과정**.
- 양식: 발생일·해결일·관련 이슈·해결 PR·발견 경로(테스트/로컬/배포/리뷰) / 현상(관찰된 사실) / 원인 추적(가설 → 검증 → 결과, 반복) / 근본 원인 / 해결 / 재발 방지

- 템플릿: api 레포 `docs/adr/0000-template.md`, `docs/troubleshooting/0000-template.md`

### 운영 원칙

- api 레포 README에 "주요 기술 결정" 3~5개, "해결한 문제" 3~5개를 요약하고 링크.
- 기록마다 관련 이슈·PR 링크 (날짜가 찍힌 이력이 사후 작성이 아니라는 증거).
- 결정·해결 **직후** 바로 작성.
- 본문은 **문답 기반**으로 작성한다.
  1. 메인 Claude가 템플릿 항목 순서로 질문하고, 논리적 빈틈("이 대안은 왜 검토 안 했나", "관찰인가 추측인가")을 짚는다. 사용자가 답한다.
  2. senior-backend가 **사용자의 답변만을 근거로** 본문을 작성한다. 답변에 없는 근거·대안·수치를 지어내지 않고, 빠진 부분은 `TODO(질문)`으로 남긴다.
  3. 사용자가 검토·수정·승인하고 직접 커밋한다 (api 레포 규칙 그대로).
  - 결정 내용과 판단은 사용자의 것이고, 에이전트는 문장화만 한다.

## 7. 사용자의 작업 선호

- 한국어로 소통.
- 추측 금지: 불확실하면 실행 전에 질문.
- 사용자는 **Windows와 macOS 양쪽에서 작업**한다.
  - 실행 명령어가 OS마다 다르면 **Windows(PowerShell)와 macOS(zsh) 두 가지를 모두** 제시한다.
  - 프로젝트 스크립트·설정(빌드, 실행, CI 등)은 두 OS에서 모두 동작하도록 작성한다. 한쪽 OS에서만 되는 경로 구분자, 셸 문법, 도구에 의존하지 않는다.

## 8. 미결정 사항

없음.

## 9. 다음 단계

PRD(00~07, `prd/seed/`)·디자인 토큰·인프라 구성(1장)은 확정됐고, v0.1 MVP 이슈는 4개 레포에 모두 생성돼 있다 (docs#1~#17, api#1~#36, web#1~#24, infra#1~#8). Epic은 4장 "v0.1 MVP Epic" 표의 8개 구현 순서 단위로 정리돼 있고 sub-issue 연결이 끝났다. Epic 1부터 차례로 끝낸다.

1. senior-backend가 API 계약 공통 규약(docs#8) 작성 → frontend 검토 → 사용자 승인
   - 읽을 것: docs#8 본문("정할 것" 항목과 완료 조건), `prd/00-overview.md` §6 공통 요구사항, 1장 "인프라 구성", 2장 senior-backend 원칙(계약 문서 형식)
   - 산출물: `api/00-common.md`, `api/openapi.yaml` 골격. 1장 조건 반영: 테스트 계정 대여·회원가입은 브라우저가 `/api`를 직접 호출
   - frontend는 web#2(앱 셸)·web#5(공통 표시 규칙)를 이 규약으로 만들 수 있는지 docs#8 코멘트로 검토 결과를 남긴다
2. designer가 빈 테스트 계정 진입 방식(목록 선택 / 자동 배정, `prd/01-trial-workspace.md` `AC-WS-02`) 안을 내고 사용자가 정한다. 이 결정 뒤에 senior-backend가 Epic 1 계약(docs#9: 세션·대여·빈 작업 공간 생성까지. 적재 결합·초기화는 Epic 6 docs#17)을 작성한다 (진입 방식에 따라 계정 목록 조회 API 유무가 갈린다)
   - 같은 작업에서 `design/tokens.md` "남은 시간 임박 표시"의 `prd/99-decisions-tbd.md` P6 참조를 `AC-COMMON-08` 참조로 바꾼다 (P6 행은 삭제됨)
3. designer가 화면 흐름·화면 스펙 작성. 산출물마다 `design/preview/`에 미리보기 HTML을 함께 만든다. Epic 1에서 쓰는 임시 화면(작업 공간 생성 뒤 앱 셸 기본 화면)과 Epic 6의 초기화 임시 진입점 모양도 designer가 정한다
4. infra가 infra#1(인프라 구성 결정 학습 가이드)·infra#2(로컬 Compose) 착수. AWS 계정 생성(Paid plan, 예산 알림 먼저)과 도메인 구매는 사용자. 나머지 infra 이슈의 착수 시점은 4장 "v0.1 MVP Epic" 참조
