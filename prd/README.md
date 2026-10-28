# dealtrail PRD (v0.1 MVP)

> 상태: **초안 (사용자 검토 전)**. 근거는 `HANDOFF.md` 0장(도메인 상세·MVP 범위·체험 방식·백엔드 설명 포인트)과 8장(미결정 사항).
> `TBD(결정 필요)`로 표시한 항목은 사용자가 결정한다. 후보와 장단점은 [`99-decisions-tbd.md`](./99-decisions-tbd.md)에 모아 둔다.

## 구성

| 파일 | 내용 | Epic 매핑 |
|---|---|---|
| [`00-overview.md`](./00-overview.md) | 제품 목표, 대상, 핵심 흐름, 용어, 공통 요구사항, MVP 제외 범위 | (Epic 아님, 공통 기준) |
| [`01-trial-workspace.md`](./01-trial-workspace.md) | 테스트 계정과 체험 작업 공간: 테스트 계정 대여, 업종 선택, 예시 데이터, 초기화, 격리, 만료·정리, 엔티티 상한 | Epic 1 |
| [`02-lead.md`](./02-lead.md) | Lead 등록·검증·전환 (Account·Contact·Opportunity 동시 생성) | Epic 2 |
| [`03-account-contact.md`](./03-account-contact.md) | Account / Contact 관리 | Epic 3 |
| [`04-opportunity-pipeline.md`](./04-opportunity-pipeline.md) | Opportunity 단계 관리 + 파이프라인 칸반 + 단계 변경 이력 | Epic 4 |
| [`05-activity.md`](./05-activity.md) | 활동 기록 (통화·미팅·할 일) | Epic 5 |
| [`06-dashboard.md`](./06-dashboard.md) | 대시보드 (단계별 금액, 수주율) | Epic 6 |
| [`07-member.md`](./07-member.md) | 회원 계정: 아이디·비밀번호 가입, 로그인, 영구 보관, 가입 남용 방지 | Epic 7 |
| [`99-decisions-tbd.md`](./99-decisions-tbd.md) | 결정 필요 항목(TBD) 목록, 후보, 장단점, PM 추천 | (문서) |

## 기능 문서의 공통 형식

각 기능 문서는 아래 순서로 쓴다.

1. **목적** — 왜 MVP에 있는가, 포트폴리오에서 무엇을 보여 주는가
2. **유저 스토리** — `~로서, ~하고 싶다, ~하기 위해`
3. **인수조건** — 검증 가능한 체크리스트. ID는 `AC-{기능약어}-{번호}`, 각 항목에 담당 영역 태그 `[FE]` `[BE]` `[공통]`을 붙인다. 작업 이슈를 만들 때 이 ID를 그대로 인용한다. 유저 스토리 ID는 `US-{기능약어}-{번호}`.
4. **제외 범위** — 이 기능에서 MVP에 넣지 않는 것
5. **의존성 / 열린 질문** — 다른 기능과의 선후 관계, TBD 참조

### ID 약자

`AC`는 항상 "인수조건(Acceptance Criteria)"을 뜻하고, 기능 약어에는 쓰지 않는다.

| 약어 | 기능 | 문서 |
|---|---|---|
| `COMMON` | 공통 요구사항 | 00 |
| `WS` | 테스트 계정과 체험 작업 공간 (Workspace) | 01 |
| `MB` | 회원 계정 (Member) | 07 |
| `LD` | Lead | 02 |
| `ACC` | Account | 03 |
| `CT` | Contact | 03 |
| `OP` | Opportunity·파이프라인 | 04 |
| `AT` | Activity | 05 |
| `DB` | 대시보드 | 06 |

예: `AC-ACC-05` = Account 인수조건 5번, `US-OP-2` = Opportunity 유저 스토리 2번.

## 우선순위 (Milestone `v0.1 MVP` 기준)

| 우선순위 | 기능 | 이유 |
|---|---|---|
| `priority:high` | 01 테스트 계정·체험 작업 공간, 02 Lead 전환, 04 Opportunity 파이프라인, 06 대시보드 | 핵심 원칙(즉시 체험)과 백엔드 설명 포인트가 집중된 기능 |
| `priority:medium` | 03 Account/Contact, 05 활동 기록, 07 회원 계정 (제안, 확정은 사용자) | 필요하지만 설명 포인트가 적고, 선행 기능이 있어야 의미가 있음. 07은 01의 흐름을 재사용하므로 01 다음에 온다 |

## 이 문서가 다루지 않는 것

- 화면 설계·컴포넌트 스펙 → `design/` (designer)
- API 계약 → `api/` (senior-backend)
- 구현 방식(트랜잭션 경계, 배치 방식, 저장 구조 등) → 사용자(백엔드)와 ADR. PRD는 **관찰 가능한 동작**만 정의한다.
