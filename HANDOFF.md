# 프로젝트 인수인계: AI 에이전트 협업 포트폴리오 프로젝트

> 이 문서는 claude.ai에서 논의해 확정한 **결정 사항**입니다.
> 에이전트 정의 파일, 템플릿, CLAUDE.md 등 실제 파일은 이 문서를 근거로 작성합니다.
> 이 문서에 없는 내용은 추측하지 말고 사용자에게 질문합니다.

---

## 0. 프로젝트 개요

- **목적**: 포트폴리오. 평가 대상은 사용자의 **백엔드 역량과 기술적 의사결정·문제 해결 능력**.
- **형태**: Claude Code 서브에이전트(PM, 디자이너, 프론트엔드, 인프라, 시니어 백엔드 리뷰어)와 협업. 사용자는 백엔드 개발 담당.
- **도메인**: 범용 B2B 영업 CRM (미니 CRM). 아래 "도메인 상세" 참고
- **프로젝트명**: `dealtrail` (deal + trail, 영업 건이 단계를 거쳐 남긴 이력). PM 후보 중 사용자가 결정
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
- 회원가입 없이 "체험하기"로 시작한다.
- 체험 시작 시 방문자가 **업종(도메인)을 선택**하면, 그 업종에 맞는 예시 데이터가 들어 있는 **방문자 전용 작업 공간**이 생성된다.
- 작업 공간은 일정 시간(예: 24시간) 후 자동 삭제된다.
- 업종 목록과 업종별 예시 데이터는 PM이 제안하고 사용자가 확정한다.

**백엔드 설명 포인트 (ADR·트러블슈팅 소재 후보)**
- Lead 전환: 여러 엔티티를 한 트랜잭션으로 생성, 중간 실패 시 전체 롤백
- Opportunity 단계 전이: 허용된 단계로만 이동하는 상태 머신 + 변경 이력
- 작업 공간 간 데이터 격리, 업종별 시드 데이터 생성, 만료 공간 정리 배치
- 파이프라인 집계 (단계별 금액 합계, 수주율)

**주의**: 서비스 이름·로고·화면은 Salesforce를 따라 하지 않는다. 개념만 참고한 자체 서비스로 만든다.

## 1. 기술 스택

| 영역 | 기술 |
|---|---|
| 프론트엔드 | Next.js |
| 백엔드 | Java Spring (필요 시 NestJS 사용 가능) |
| DB | PostgreSQL |
| 배포 | AWS. **EKS 사용 안 함** (개인 프로젝트라 비용 문제) |

### 인프라 원칙

- 이 프로젝트에서 사용자는 **AWS와 Terraform을 잘 모르는 사람**으로 가정한다.
- 어려운 기술은 쓰지 않는다. 쿠버네티스는 쉽고 비용이 들지 않는 경우에만 고려하고, 아니면 EC2 또는 ECS 수준으로 간단히 간다.
- 현재 의견: 운영 난이도 때문에 쿠버네티스(k3s 포함)는 제외하는 쪽이 낫다. 비용상 "EC2 한 대 + Docker Compose"가 가장 저렴·단순하고, ECS(Fargate)는 관리가 편하지만 로드밸런서 등 월 고정비가 생긴다.
- **최종 선택은 인프라 에이전트가 비용 비교표와 함께 제안하고 사용자가 결정한다.** (미결정)

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
- 도구 권한: pm·senior-backend 모두 Edit/Write를 열어 둔다. "pm은 코드를 작성하지 않는다"는 에이전트 정의 파일의 정책으로만 둔다 (2026-10-28).
- frontend: 백엔드에 문제가 있을 때만 api 코드에 접근할 수 있고, **코드를 수정하지 않고 원인을 분석해 이슈만 생성**한다.
- 그 외 에이전트는 api 레포에 접근하지 않는다.

## 3. 레포 구성

GitHub **Organization**(무료)을 새로 만들고 아래 레포를 둔다. (Organization 이름은 도메인 확정 후 결정)

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

- 에이전트 커밋 권한: docs / web / infra 만.
- 에이전트 커밋·PR에 `Co-Authored-By` 꼬리말이나 AI 작성 문구를 붙이지 않는다. Claude Code는 기본으로 붙이므로 docs 레포 `.claude/settings.json`의 `attribution` 설정으로 끈다. → `"attribution": false`로 적용 (v2.1.281 이상 필요, Windows·macOS 모두 최신 버전 사용 중. 2026-10-28)
- ~~api 레포 `main`에는 브랜치 보호(PR 필수)를 건다.~~ → 걸지 않기로 결정 (2026-10-28). 작업자가 사용자 한 명뿐이고 실제 프로덕트가 아니므로 PR 머지는 규칙으로만 지킨다.

## 4. 이슈 기반 프로젝트 관리

### 구조

- **Milestone**: 출시 단위 (예: `v0.1 MVP`)
- **Epic 이슈**: PRD의 기능 하나. **docs 레포**에 생성. PM이 생성.
- **작업 이슈**: 코드가 바뀌는 레포에 생성. `[FE]` → web, `[BE]` → api, `[INFRA]` → infra.
- **Issue type** (org 단위 GitHub Issue types): `Epic` / `Feature` / `Bug` / `Task`
  - chore·문서 작업은 `Task`로 묶는다. `Epic`은 docs 레포의 Epic 이슈에만 쓴다.
  - ~~라벨 `type:feature` / `type:bug` / `type:chore` / `type:docs`~~ → Issue type으로 대체 (2026-10-28). 이슈당 종류가 하나로 강제되고 Projects 보드에서 필드로 다룰 수 있어서.
- **Label**
  - 영역: `area:web` / `area:api` / `area:infra` / `area:design`
  - 우선순위: `priority:high` 등
- **조직 단위 GitHub Projects 보드** 하나로 전 레포 이슈를 칸반(할 일 / 진행 중 / 리뷰 중 / 완료)으로 본다.

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

### 세팅 시 확인 필요

- [ ] 다른 레포 간 sub-issue 연결이 되는지. 안 되면 Epic 본문에 체크리스트로 작업 이슈 링크. → PM이 만드는 첫 Epic에서 확인 (2026-10-28)
- [ ] GitHub MCP로 Projects 보드 조작이 되는지. 안 되면 `status:in-progress` 같은 라벨로 상태 관리.

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

### 템플릿 (작성 필요)

- **커밋 템플릿** `.gitmessage`: 제목 형식 / 본문(무엇을, 왜) / 꼬리말(Closes, BREAKING CHANGE) 가이드. 적용: `git config commit.template .gitmessage`
- **PR 템플릿**: 관련 이슈(Closes #) / 변경 내용 / 확인 방법 체크리스트 / 리뷰어에게(특히 봐줬으면 하는 부분)
- **이슈 템플릿**
  - feature: 배경, 유저 스토리, 인수조건 체크리스트, 관련 문서 링크(PRD·디자인·API)
  - bug: 현상, 재현 절차, 기대 동작, 환경
  - task: 작업 내용, 완료 조건 (chore·인프라·문서용)
- 이슈/PR 템플릿은 `.github` 레포에 두어 전 레포에 공용 적용.

## 6. 기술 결정·문제 해결 기록

문제 해결 사고력의 근거를 남기기 위한 기록. **api 레포**에 둔다 (인프라 결정이라도 "에이전트 제안 중 이 이유로 골랐다"는 판단은 사용자의 것이고, 평가받는 곳에 모여 있어야 함).

### (1) ADR: `docs/adr/0001-제목.md`

- 작성 기준: 되돌리는 비용이 크거나, 대안을 실제로 2개 이상 검토한 결정.
- 양식: 상태·날짜·관련 이슈 / 맥락 / 검토한 대안(장단점 표) / 결정과 결정적 이유 / 결과와 트레이드오프(재검토 조건 포함)

### (2) 트러블슈팅: `docs/troubleshooting/0001-제목.md`

- 핵심은 **실패한 가설까지 포함한 과정**.
- 양식: 날짜·관련 이슈·해결 PR / 현상(관찰된 사실) / 원인 추적(가설 → 검증 → 결과, 반복) / 근본 원인 / 해결 / 재발 방지

### 운영 원칙

- api 레포 README에 "주요 기술 결정" 3~5개, "해결한 문제" 3~5개를 요약하고 링크.
- 기록마다 관련 이슈·PR 링크 (날짜가 찍힌 이력이 사후 작성이 아니라는 증거).
- 결정·해결 **직후** 바로 작성.
- **본문은 사용자가 직접 작성.** 메인 Claude는 템플릿에 맞는 질문으로 작성을 돕고, senior-backend는 논리적 빈틈("이 대안은 왜 검토 안 했나")을 리뷰. 에이전트가 대신 쓰지 않는다.

## 7. 사용자의 작업 선호

- 한국어로 소통.
- 추측 금지: 불확실하면 실행 전에 질문.
- 사용자는 **Windows와 macOS 양쪽에서 작업**한다.
  - 실행 명령어가 OS마다 다르면 **Windows(PowerShell)와 macOS(zsh) 두 가지를 모두** 제시한다.
  - 프로젝트 스크립트·설정(빌드, 실행, CI 등)은 두 OS에서 모두 동작하도록 작성한다. 한쪽 OS에서만 되는 경로 구분자, 셸 문법, 도구에 의존하지 않는다.

## 8. 미결정 사항

- [x] ~~도메인~~ → 범용 B2B 영업 CRM으로 확정 (0장)
- [x] ~~프로젝트명~~ → `dealtrail`로 확정 (0장)
- [x] ~~Organization 이름~~ → `dealtrail-crm`으로 확정 (`dealtrail`은 GitHub에서 이미 사용 중). 레포 이름은 `dealtrail-*` 그대로 사용
- [ ] 체험 시 선택 가능한 업종 목록과 업종별 예시 데이터 (PM 제안 → 사용자 확정)
- [ ] 체험 작업 공간 유지 시간 (예: 24시간)
- [ ] 배포 방식 (EC2 + Docker Compose vs ECS) → infra 에이전트가 비용 비교 후 제안
- [ ] GitHub MCP 연결 (Fine-grained PAT, `--scope user`로 등록. 프로젝트 범위 `.mcp.json`에 토큰 넣지 않기)
- [ ] 세팅 시 확인 항목 (4장)

## 9. 다음 단계 제안 순서

프로젝트명을 PM 에이전트에게 받으려면 에이전트가 먼저 있어야 하므로, docs 폴더를 임시 이름으로 로컬에서 시작한다.

1. 로컬에 임시 docs 폴더(예: `workspace/crm-docs`)를 만들고 이 문서를 넣은 뒤 `git init`
2. CLAUDE.md, `.claude/agents/` 정의 파일 작성 (이 문서 기준, 작성 전 사용자 확인)
3. PM 에이전트에게 프로젝트명 후보 요청 → 사용자 결정
4. Organization과 레포 5개 생성, 로컬 폴더 이름을 `{프로젝트명}-docs`로 바꾸고 push
5. GitHub MCP 연결 확인 (4장의 세팅 시 확인 항목 포함)
6. `.github` 레포에 공용 템플릿, api 레포에 ADR·트러블슈팅 템플릿 작성
7. 첫 ADR: "레포를 이렇게 나눈 이유"
8. PM 에이전트로 PRD 작성 시작 (체험 업종 목록·예시 데이터 제안 포함)
