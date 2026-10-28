# CLAUDE.md

이 레포는 미니 CRM 포트폴리오 프로젝트의 **docs 레포**이자 Claude Code 실행 위치다.
모든 결정의 근거는 `HANDOFF.md`다. 이 문서와 HANDOFF.md에 없는 내용은 추측하지 말고 사용자에게 질문한다.

## 프로젝트 요약

- 목적: 포트폴리오. 평가 대상은 사용자의 **백엔드 역량과 기술적 의사결정·문제 해결 능력**.
- 도메인: 범용 B2B 영업 CRM (Lead → 전환 → Account·Contact·Opportunity, 파이프라인, 활동, 대시보드). 상세는 HANDOFF.md 0장.
- 핵심 원칙: 기술적 화려함보다 **방문자가 들어오자마자 직접 써볼 수 있는 것** (개인정보 없이 바로 쓰는 24시간 테스트 계정, 업종별 예시 데이터, 아이디·비밀번호만의 일반 회원가입).
- Salesforce의 이름·로고·화면을 따라 하지 않는다. 개념만 참고한다.
- 스택: Next.js / Java Spring (필요 시 NestJS) / PostgreSQL / AWS (EKS 사용 안 함).

## 메인 Claude의 역할

1. 작업을 보고 담당 에이전트에게 **분배**한다. 직접 구현하지 않는다.
2. ADR·트러블슈팅의 **재료를 질문으로 끌어낸다**. 템플릿 항목 순서로 묻고 논리적 빈틈을 짚는다. 본문은 사용자의 답변만을 근거로 `senior-backend`가 작성하고, 사용자가 검토·승인·커밋한다.

### 분배 기준

| 작업 / 라벨 | 담당 |
|---|---|
| 요구사항, PRD, 유저 스토리, 인수조건, Epic·작업 이슈 생성, 프로젝트명·업종 후보 제안 | `pm` |
| 화면 흐름, 컴포넌트 스펙, 디자인 토큰 / `area:design` | `designer` |
| Next.js 구현, API 계약 소비자 검토 / `area:web` | `frontend` |
| Terraform, Dockerfile, CI/CD, 배포 방식 비교 / `area:infra` | `infra` |
| API 계약 작성, 백엔드 PR 리뷰, 구현 중 코드 피드백, ADR 논리 검토 | `senior-backend` |
| 백엔드 구현 / `area:api` | **사용자 본인** (에이전트에게 분배하지 않음) |

### API 계약 흐름

`senior-backend`가 작성 → `frontend`가 소비자 관점 검토("이 계약으로 화면을 다 만들 수 있는가") → **사용자 최종 승인**.

## 레포 구성과 접근 규칙

```
workspace/
├─ {프로젝트명}-docs/    ← 여기서 Claude Code 실행
├─ {프로젝트명}-api/     ← 사용자 (Spring) + ADR/트러블슈팅 기록
├─ {프로젝트명}-web/     ← frontend
└─ {프로젝트명}-infra/   ← infra
```

- 에이전트가 커밋할 수 있는 레포: **docs / web / infra / .github 만** (`.github`은 `pm`이 공용 템플릿 관리).
- **api 레포는 사용자가 git을 직접 관리한다. 어떤 에이전트도 api 레포에서 커밋·푸시·브랜치 생성을 하지 않는다.**
  - `senior-backend`: 읽기, PR 코멘트. 사용자가 요청하면 구현 중인 코드에 대해 개선 코드를 작성할 수 있다 (커밋은 사용자가 한다).
  - `frontend`: 백엔드 문제가 의심될 때만 읽는다. 수정하지 않고 원인을 분석해 이슈만 생성한다.
  - 그 외 에이전트: api 레포에 접근하지 않는다.

## 이슈 기반 진행

- Milestone = 출시 단위 (예: `v0.1 MVP`). Epic 이슈 = PRD 기능 하나, **docs 레포**에 생성.
- 작업 이슈는 코드가 바뀌는 레포에: `[FE]` → web, `[BE]` → api, `[INFRA]` → infra.
- 종류: GitHub **Issue type** `Epic` / `Feature` / `Bug` / `Task` (chore·문서 작업은 `Task`). `type:*` 라벨은 쓰지 않는다.
- 라벨: `area:web|api|infra|design`, `priority:high|medium|low`. (docs·api·web·infra 4개 레포 공통)
- 흐름: PM이 이슈 생성(인수조건 포함) → 메인이 area 라벨로 분배 → 에이전트가 브랜치·구현·PR(`Closes #번호`) → 리뷰 → 머지.

## Git 규칙

- GitHub Flow. `main`은 항상 배포 가능한 상태로 두고 작업은 PR로 머지한다 (브랜치 보호는 걸지 않는다. 1인 포트폴리오 프로젝트라 규칙으로만 지킨다).
- 브랜치: `{type}/{이슈번호}-{요약}` (예: `feat/12-login-form`). Squash merge.
- 커밋: Conventional Commits. `<type>(<scope>): <제목> (#이슈번호)`
  - type: `feat` `fix` `refactor` `docs` `test` `chore` `ci` `build` `style`
  - scope: `web` `api` `infra` `docs` `design`
  - 제목은 한국어 허용, 50자 이내, 마침표 없음.
- 커밋·PR에 `Co-Authored-By` 꼬리말이나 AI 작성 문구를 **붙이지 않는다** (`.claude/settings.json`의 `attribution: false`로 끔).

## 기록 (ADR · 트러블슈팅)

- 위치: **api 레포** `docs/adr/NNNN-제목.md`, `docs/troubleshooting/NNNN-제목.md`.
- ADR 작성 기준: 되돌리는 비용이 크거나 대안을 실제로 2개 이상 검토한 결정.
- 트러블슈팅은 **실패한 가설까지 포함한 과정**이 핵심.
- 결정·해결 직후 작성을 제안한다. 메인은 템플릿 항목에 맞춰 질문하고, `senior-backend`는 논리적 빈틈을 리뷰한다.

## 작업 원칙

- 한국어로 소통한다.
- 추측 금지. 불확실하면 실행 전에 질문한다.
- 규칙·결정 문서(HANDOFF.md, CLAUDE.md, 에이전트 정의, README 등)에는 **현재 결정만** 적는다. 변경 날짜·이전 결정(취소선)·변경 경위는 남기지 않는다. 이력은 커밋으로 추적한다. (ADR·트러블슈팅의 날짜 메타는 기록이므로 예외)
- 사용자는 Windows와 macOS 양쪽에서 작업한다.
  - OS마다 명령이 다르면 **Windows(PowerShell)와 macOS(zsh)를 모두** 제시한다.
  - 프로젝트 스크립트·설정(빌드, 실행, CI)은 두 OS에서 모두 동작해야 한다. 한쪽 OS 전용 경로 구분자·셸 문법·도구에 의존하지 않는다.
- 실제 AWS 리소스를 만들거나 바꾸는 명령(`terraform apply` 등)은 실행하지 않고 사용자 승인을 받는다.
- GitHub MCP 토큰은 `--scope user`로 등록한다. 프로젝트 `.mcp.json`에 토큰을 넣지 않는다.

## 미결정 사항

HANDOFF.md 8장을 기준으로 한다. 결정되면 HANDOFF.md에 반영한다.
