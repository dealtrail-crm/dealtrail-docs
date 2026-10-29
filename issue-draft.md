# Milestone · Epic · 작업 이슈 생성 초안 (v0.1 MVP) — 개정판

> 이 문서는 **초안**이다. GitHub에는 아무것도 생성하지 않았다. 사용자 승인 후 생성한다.
> 근거: `HANDOFF.md` 4장·9장, `prd/README.md`, `prd/00~07`, `prd/seed/`.
> 사용자 결정 D1~D9(7장)를 반영했다. 분할 기준은 **대안 B(AC 2~4개당 이슈 하나)**.

## 0. 읽기 전용 확인 결과

| 항목 | 결과 |
|---|---|
| 인증 사용자 | `yshong1998` |
| Organization | `dealtrail-crm`. 레포 5개: `dealtrail-docs`, `dealtrail-api`, `dealtrail-web`, `dealtrail-infra`, `.github` (모두 public, 기본 브랜치 `main`) |
| 라벨 | 4개 레포(docs·api·web·infra) 모두 `area:web|api|infra|design`, `priority:high|medium|low` 7개 있음. **`area:docs`는 없음 → 4개 레포에 새로 만든다 (D8, 승인 후)** |
| org Issue type | `Epic`, `Feature`, `Bug`, `Task` 4종 모두 존재·활성 |
| 기존 이슈 | 4개 레포 모두 0건 |
| 기존 Milestone | 4개 레포 모두 없음 → `v0.1 MVP`를 **4개 레포 각각에** 만든다 (Milestone은 레포 단위). 기한 없음 (D5) |
| `.github` 레포 | `.github/ISSUE_TEMPLATE/{feature,bug,task}.md`(frontmatter `type:` 포함)와 `pull_request_template.md` 있음. 제목 접두어 주석에는 `[FE]/[BE]/[INFRA]`만 있음 → `[DOCS]` 추가 필요 (6.4절) |
| Projects 보드 | GitHub MCP에 Projects 도구 없음 → 사용자가 **gh CLI** `gh issue create --project "Dealtrail Issue Tracker"`로 보드에 추가하기로 결정 (8장) |
| 레포 간 sub-issue | MCP `sub_issue_write`·`issue_write(parent_*)` 있음. 다른 레포 이슈를 sub-issue로 붙일 수 있는지는 **첫 Epic에서 확인**. 안 되면 Epic 본문 체크리스트로 대신한다 |

---

## 1. Milestone

| 레포 | 이름 | 설명 | 기한 |
|---|---|---|---|
| docs / api / web / infra 각각 | `v0.1 MVP` | HANDOFF 0장 MVP 범위. PRD 00~07의 인수조건이 모두 통과하면 종료 | 없음 (D5) |

---

## 2. Epic (docs 레포, Issue type `Epic`)

### 2.1 우선순위와 라벨

우선순위는 초안 그대로 (D1). Epic에도 **하위 작업 이슈가 있는 영역의 `area:*` 라벨을 모두** 붙인다 (D4). 모든 Epic이 `[BE]`(api) · `[FE]`(web) · API 계약(docs) 하위 이슈를 가지므로 7개 모두 `area:api` `area:web` `area:docs`다. designer 산출물이 Epic 하위 이슈로 생기면 그때 `area:design`을 추가한다.

| Epic | 제목 | 우선순위 | area | 근거 한 줄 |
|---|---|---|---|---|
| E1 | `[Epic] 테스트 계정과 체험 작업 공간` | `priority:high` | api · web · docs | 모든 기능의 전제. 설명 포인트 4개(대여 경쟁·생성·시드·격리·정리 배치)가 여기 있다 |
| E2 | `[Epic] Lead 등록·검증·전환` | `priority:high` | api · web · docs | 설명 포인트 "트랜잭션 전환" |
| E3 | `[Epic] Account / Contact 관리` | `priority:medium` | api · web · docs | 설명 포인트 없음. 단, Epic 4 선행이라 BE 생성·수정 이슈는 `priority:high` (D3, 4.3절) |
| E4 | `[Epic] Opportunity 단계 관리와 파이프라인 칸반` | `priority:high` | api · web · docs | 설명 포인트 "상태 머신 + 이력", 기본 진입 화면 |
| E5 | `[Epic] 활동 기록 (Activity)` | `priority:medium` | api · web · docs | 설명 포인트 없음. 전환 시 활동 이동은 E2의 B18에서 |
| E6 | `[Epic] 대시보드` | `priority:high` | api · web · docs | 설명 포인트 "집계" |
| E7 | `[Epic] 회원 계정` | `priority:medium` | api · web · docs | 01의 흐름 재사용 |

### 2.2 Epic 본문 형식 (공통)

```
## 목적
(PRD §1 요약 2~3줄)

## PRD
- prd/0N-....md

## 설명 포인트 (해당 시)
- {포인트명} — 핵심 이슈: dealtrail-crm/dealtrail-api#.. (ADR·트러블슈팅은 이 이슈를 가리킨다). 관련: #.., #..

## API 계약
- [ ] dealtrail-crm/dealtrail-docs#..  [DOCS] API 계약: ...   ← 이 Epic의 FE 이슈 착수 조건

## 작업 이슈
<!-- 레포 간 sub-issue 연결이 되면 이 목록은 sub-issue로 대신한다. 안 되면 체크리스트 유지 -->
- [ ] dealtrail-crm/dealtrail-api#..  [BE] ...
- [ ] dealtrail-crm/dealtrail-web#..  [FE] ...

## 완료 기준
- API 계약 이슈가 사용자 승인으로 닫힘
- 위 작업 이슈가 모두 닫힘
- PRD 인수조건 AC-XX-01~NN이 모두 체크됨
```

---

## 3. 분할 기준 (채택: 대안 B)

사용자가 "ADR 작성에 더 유리한 쪽"으로 **대안 B(AC 2~4개당 이슈 하나)**를 골랐다 (D2). 적용 규칙:

1. **이슈 하나 = AC 2~4개**가 원칙. 화면·기능 경계상 자연스럽지 않으면 1개나 5개도 허용하되 각 이슈 비고에 이유를 적는다.
2. **설명 포인트 하나는 여러 이슈로 쪼개질 수 있지만, 이슈 하나에 설명 포인트 두 개가 섞이지 않는다.** 포인트가 겹칠 수 있는 AC(예: 전환 중 다른 작업 공간의 Account 지정 `AC-LD-19`)는 한 포인트(격리)의 이슈에만 인용하고 다른 쪽은 참조로만 적는다.
3. **설명 포인트별 "핵심 이슈" 하나**를 표시한다. ADR·트러블슈팅의 "관련 이슈"는 핵심 이슈를 가리킨다. 핵심 이슈 본문에는 "구현 시 결정할 것"(ADR 소재)을 둔다.
4. **선행 관계**를 이슈마다 적는다. 선행은 "그 이슈가 닫히기 전에는 이 이슈를 완료(PR 머지)할 수 없다"는 뜻이다.
5. AC ID를 이슈 본문에 그대로 인용하고 PRD 원문은 링크로 대신한다 (복사하지 않는다 → PRD가 단일 기준).

### 설명 포인트 ↔ 핵심 이슈

| 설명 포인트 | 핵심 이슈 | 포인트가 걸친 다른 이슈 | ADR·트러블슈팅 소재 (PRD가 "사용자 결정"으로 남긴 것) |
|---|---|---|---|
| 테스트 계정 동시 대여 경쟁 | **B04** | B03(대여 모델·시작), B05(로그인·모두 사용 중) | 한 명만 성공시키는 방식 (`AC-WS-05`), IP 동시 대여 판정 |
| 작업 공간 생성·시드 | **B08** | B07(생성 요청·원자성), B09(업종별 데이터 3종) | 명세의 기계 판독 형식, 과거 시각 적재, 업종 추가가 데이터 추가 수준이 되는 구조 (`AC-WS-20` `22`) |
| 작업 공간 격리 | **B11** | B12(교차 검증 테스트) | 세션→작업 공간 결정 위치, "존재하지 않음" 일원화, 추측 불가 식별자 (`AC-COMMON-02` `AC-WS-27`) |
| 만료 대여 정리 배치 | **B13** | B06(만료 판정과 삭제의 분리) | 앱 내 스케줄러로 확정. 대여 모델링, 중복 실행 방지, 수동 트리거, 주기 설정값 (B13 본문 "구현 시 결정할 것") |
| Lead 전환 트랜잭션 | **B16** | B17(생성물 규칙), B18(활동 이동) | 트랜잭션 경계, 롤백 검증 방법, 중복 전환 방지 (`AC-LD-12` `16`) |
| 단계 상태 머신 + 이력 | **B26** | B27(종료 잠금·동시 전이·이력 불변) | 전이 표의 표현, 단계 변경과 이력 기록의 원자성, 동시 전이 제어 (`AC-OP-10` `11`) |
| 파이프라인 집계 | **B33** | B28(파이프라인 조회), B34(수주율·정합성 테스트) | 매 요청 계산 vs 캐시, 반영 지연 여부 (`AC-DB-04`) |

### `[공통]` 태그 AC 처리

- `[공통]` AC는 FE 이슈와 BE 이슈 양쪽에 같은 ID를 인용하고, 각 이슈 본문의 해당 줄 끝에 괄호로 담당 부분을 적는다. 예: `AC-COMMON-10 (BE: 8자 미만 거부 / FE: 입력란 옆 규칙 표시)`.
- `AC-COMMON-*`은 Epic이 없다(00은 공통 기준). 앱 셸·공통 표시 규칙 FE 이슈(F02 F03 F05)와 세션·비밀번호 BE 이슈(B01 B02)는 **Epic 1 하위**에 둔다 (Epic 1이 모든 기능의 전제이고, 이 AC들이 01의 테스트 계정 흐름에서 처음 쓰인다). — 사용자 확인 항목 (7장 Q4)
- 예외: `AC-COMMON-07`(자체 디자인, designer 검토)은 코드 이슈가 아니다. `AC-WS-21`(가상 회사명·인명)은 B09에 "명세 준수 확인"으로만 둔다.
- `AC-COMMON-04`(페이지네이션)는 엔티티별 BE 목록 이슈와 FE 목록 이슈 각각에 인용한다. 방식은 공통 계약 C0에서 정한다.
- `AC-WS-37`(엔티티 상한 200)은 엔티티별 AC(`AC-ACC-09` `AC-OP-23` `AC-AT-12`)를 해당 이슈에 인용하고, Lead는 전용 AC가 없어 B14에 `AC-WS-37`을 직접 인용한다. "전환 시 어느 하나라도 초과하면 전체 거부"는 B16에 인용한다.
- 격리 AC(`AC-ACC-08` `AC-OP-22` `AC-AT-11` `AC-LD-19` `AC-DB-06`)는 모두 **B12**에 인용하고, 각 엔티티 BE 이슈에는 "조회·수정은 B11 공통 메커니즘을 거친다"로만 참조한다 (포인트 섞임 방지).

---

## 4. 작업 이슈 목록

표기: 번호(`B..`=api `[BE]`, `F..`=web `[FE]`, `C..`=docs API 계약)는 이 초안 안의 참조 번호이며 GitHub 번호가 아니다.
Issue type은 `[BE]`·`[FE]` 모두 `Feature`, API 계약은 `Task`. Milestone은 모두 `v0.1 MVP`. 라벨의 `area:*`는 레포로 정해지므로(api→`area:api`, web→`area:web`, docs 계약→`area:docs`) 표에는 `priority:*`만 적는다.
"AC 수"는 인용 AC 개수(참조는 제외). 2~4 밖이면 비고에 이유.

작업 이슈 본문 형식은 `.github` Feature 템플릿 그대로: 배경(Epic 링크) / 유저 스토리(PRD US 인용) / 인수조건(AC ID + 담당 부분) / 관련 문서(PRD 경로, 디자인·API 계약은 생기면 링크). 핵심 이슈에는 "구현 시 결정할 것" 절을 추가한다.

**모든 FE 이슈의 공통 선행**: C0(공통 계약)과 해당 Epic의 계약 이슈 승인. 계약 전에는 F01·F02의 정적 부분만 가능하다.

### 4.1 Epic 1. 테스트 계정과 체험 작업 공간 — `prd/01-trial-workspace.md`, `prd/00-overview.md` §6, `prd/seed/`

#### `[BE]` (api 레포, 모두 `priority:high`)

| # | 제목 | 인용 AC | AC 수 | 설명 포인트 | 선행 | 비고 |
|---|---|---|---|---|---|---|
| B01 | `[BE] 로그인 세션 발급·검증·로그아웃` | `AC-COMMON-09` `12`(BE) `13` `14`(BE) | 4 | 없음 | 없음 | 세션 보관 수단·형식은 C0 |
| B02 | `[BE] 비밀번호 규칙 검증과 저장` | `AC-COMMON-10`(BE) `11` | 2 | 없음 | 없음 | 테스트 계정·회원이 공유하는 규칙이라 분리. 저장 방식은 사용자 결정 |
| B03 | `[BE] 테스트 계정 풀과 대여 시작 (비밀번호 설정 = 대여, 만료 시각)` | `AC-WS-01` `03` `29` | 3 | 대여 경쟁 (기반) | B01 B02 | 계정 수는 설정값 |
| **B04** | `[BE] 동시 대여 경쟁 — 한 명만 성공, IP 동시 대여 1개` | `AC-WS-05` `06` | 2 | **대여 경쟁 (핵심)** | B03 | 둘 다 "동시 요청 중 하나만 통과" 규칙. `AC-WS-05` 자동 테스트 필수. IP 식별 방법은 infra 결정 대기(`X-Forwarded-For` 등) → 그때까지 직접 연결 IP 기준으로 구현해도 AC는 성립 |
| B05 | `[BE] 테스트 계정 로그인 규칙·모두 사용 중 응답·로그` | `AC-WS-04` `07`(BE: 가장 이른 만료 시각) `08` `10`(BE: 만료 전 재로그인) | 4 | 대여 경쟁 (주변) | B03 | `AC-WS-09`(비밀번호 찾기·변경 없음)는 "제공하지 않음" 확인으로만 둔다 |
| B06 | `[BE] 만료 대여 요청 거부 ("만료됨" 구분)와 만료 즉시 재대여 가능` | `AC-COMMON-03` `AC-WS-31` `AC-DB-12`(공통 규칙 적용 확인) | 3 | 정리 배치 (만료 판정과 삭제의 분리) | B03 | 정리 작업 전이라도 시각 비교만으로 거부·재대여. B13의 ADR 맥락이 된다 |
| B07 | `[BE] 작업 공간 생성 요청 — 업종 검증, 계정당 하나, 생성·적재 한 요청` | `AC-WS-13` `15`(BE: 수 초 이내) `16` `17` | 4 | 생성·시드 | B01, 엔티티 BE(B14 B15 B19 B21 B23 B26 B29) | 적재가 끝난 공간만 돌려준다 |
| **B08** | `[BE] 예시 데이터 적재기 — 명세 형식·상대 날짜·원자성·업종 추가 구조` | `AC-WS-14` `19` `20` `22` | 4 | **생성·시드 (핵심)** | B07 | 구현 시 결정할 것: 명세의 기계 판독 형식(JSON·YAML·SQL), 과거 시각 적재 방법, 업종 추가 시 코드 변경 없는 구조, 적재 실패 시 공간이 남지 않게 하는 경계 |
| B09 | `[BE] 업종별 예시 데이터 3종 적재와 명세 기대값 검증` | `AC-WS-18` `AC-ACC-11` (+ `AC-WS-21` 명세 준수 확인) | 2 | 생성·시드 | B08 | `seed/*.md` §8 기대값(수주율 75%, 지연 2, 미완료 할 일 3 등)을 자동 테스트로. 적재기(코드)와 데이터(내용)를 나눈 것이라 2개 |
| B10 | `[BE] 초기화 — 작업 공간 전체 삭제 원자성, 계정·세션 유지` | `AC-WS-24` `25` | 2 | 없음 | B07 | 독립 기능. 정리 배치(B13)와 삭제 루틴을 공유할지는 사용자 판단 |
| **B11** | `[BE] 작업 공간 격리 공통 메커니즘 — 세션→작업 공간, "존재하지 않음", 추측 불가 식별자` | `AC-COMMON-01` `02` `AC-WS-27` | 3 | **격리 (핵심)** | B01 | 모든 엔티티 CRUD의 선행. 구현 시 결정할 것: 작업 공간 결정 위치(필터·인터셉터·서비스), 존재하지 않음 응답 일원화, 식별자 생성 방식 |
| B12 | `[BE] 격리 교차 검증 자동 테스트 — 두 계정, 재대여 후 이전 데이터 차단` | `AC-WS-26` `28` `AC-LD-19` `AC-ACC-08` `AC-OP-22` `AC-AT-11` `AC-DB-06` | 7 | 격리 | B11, Epic 2~6 BE 전부 | **AC 7개 예외**: 뒤 5개는 "엔티티별로 B11이 성립함"을 한 시나리오로 검증하는 것이라 분리하면 이슈마다 테스트 1개가 된다. 교차 시나리오 하나로 묶는다 |
| **B13** | `[BE] 만료 대여 정리 배치 (앱 내 스케줄러)` | `AC-WS-32` `33` `34` `35` `36` (+ `AC-MB-04` BE: 회원은 대상 아님) | 5 | **정리 배치 (핵심)** | B03 B06 B10 | **AC 5개 예외**: 실행 방식과 동시 실행 방지를 하나의 ADR로 묶기로 했으므로 이슈도 하나. 본문은 아래 4.1.1 |

##### 4.1.1 B13 본문에 넣는 "구현 시 결정할 것"

실행 방식은 **앱 안 스케줄러(Spring `@Scheduled`)로 확정**됐다 (외부 트리거 이슈 I-d는 삭제). 나머지는 구현 시 사용자가 정하고 ADR로 남긴다.

- 대여 모델링: 테스트 계정 행에 대여 컬럼(비밀번호·시작·만료)을 두는가, 대여를 별도 행으로 분리하는가. 분리하면 `AC-WS-28`(재대여 후 이전 데이터 차단)과 정리 대상 식별이 쉬워지는 대신 조인이 늘어난다.
- 중복 실행 방지의 위치(`AC-WS-36`): 스케줄러 수준 락(ShedLock 등)으로 한 번에 하나만 돌게 할 것인가, 행 단위 원자 처리(`FOR UPDATE SKIP LOCKED` 등)로 둘이 돌아도 한 대여를 한 번만 집게 할 것인가. 인스턴스가 하나인 배포(EC2+Compose)와 둘 이상(ECS)에서 답이 다를 수 있다 → infra 결정과 연결.
- 테스트용 보호된 수동 트리거를 둘 것인가(`AC-WS-33`·`34` 검증과 운영 확인용). 둔다면 인증 방식과 노출 범위.
- 정리 주기를 설정값으로 둘 것인가(`AC-WS-32` 허용 지연 1시간 안에서).
- ADR 범위: **실행 방식 + 동시 실행 방지를 하나의 ADR로 묶는 것을 권장**. 대여 모델링은 B03과 공유하는 결정이므로 같은 ADR에 포함하거나 별도 ADR로 분리할지 그때 정한다.

#### `[FE]` (web 레포, 모두 `priority:high`)

| # | 제목 | 인용 AC | AC 수 | 선행 | 비고 |
|---|---|---|---|---|---|
| F01 | `[FE] 첫 화면과 체험 시작 (테스트 계정 비밀번호 설정)` | `AC-WS-02` `07`(FE: 모두 사용 중·가장 빨리 비는 시각·회원가입 진입) `09`(FE 안내) `AC-COMMON-10`(FE 규칙 표시) | 4 | C1 | 빈 계정 진입 방식(목록/자동 배정)은 designer 결정 대기 |
| F02 | `[FE] 앱 셸 — 세션 처리, 인증 필요 안내, 로그아웃` | `AC-COMMON-09`(FE) `12`(FE) `14`(FE) `AC-WS-10`(FE) | 4 | C0 C1 | 레이아웃·내비게이션 포함 |
| F03 | `[FE] 남은 시간 표시·만료 안내·상한 안내` | `AC-COMMON-08` `AC-WS-30` `11` `38` | 4 | F02 | 08과 30은 같은 내용의 두 ID. 표시 방식은 designer |
| F04 | `[FE] 업종 선택 화면·작업 공간 생성·초기화 흐름` | `AC-WS-12` `15`(FE 로딩) `23` | 3 | F02 | 초기화 버튼 자체는 대시보드(F23)에 놓이고, 확인→삭제→업종 선택 복귀 흐름은 이 이슈 |
| F05 | `[FE] 공통 표시 규칙 — 필드 오류 표시, 금액(KRW), 한국 시간 날짜·지연 판정 유틸` | `AC-COMMON-05`(FE 표시) `06`(FE) `15`(FE) | 3 | C0 | 지연 판정(`AC-OP-19` `AC-AT-09`)이 이 유틸을 쓴다. 다른 FE 이슈보다 먼저 |

### 4.2 Epic 2. Lead 등록·검증·전환 — `prd/02-lead.md`

#### `[BE]` (`priority:high`)

| # | 제목 | 인용 AC | AC 수 | 설명 포인트 | 선행 | 비고 |
|---|---|---|---|---|---|---|
| B14 | `[BE] Lead 생성·수정·목록 (필수값·이메일 검증, 상한)` | `AC-LD-01`(BE) `04` `AC-COMMON-04`(Lead) `AC-WS-37`(Lead 상한) | 4 | 없음 | B11 | |
| B15 | `[BE] Lead 상태 전이와 전환된 Lead 잠금` | `AC-LD-05`(BE) `07` `08` `09` | 4 | 없음 | B14 | 삭제 시 활동 종속 삭제(`AC-AT-05`)는 B30 |
| **B16** | `[BE] Lead 전환 트랜잭션 — 전체 성공/전체 롤백, 중복 전환 방지` | `AC-LD-11` `12` `16` `AC-WS-37`(전환 시 하나라도 초과 → 전체 거부) | 4 | **전환 트랜잭션 (핵심)** | B15 B17 B18 B19 B21 B23 B26 | `AC-LD-12` 두 경로 롤백 자동 테스트, `AC-LD-16` 동시 전환 테스트 필수. 구현 시 결정할 것: 트랜잭션 경계, 실패 주입 방법, 중복 전환 제어(상태 조건부 갱신·락) |
| B17 | `[BE] 전환 생성물 규칙 — 연결, 첫 단계 "발굴"과 이력 1건, 출처 Lead 기록` | `AC-LD-13` `14` `15` `AC-ACC-06` `AC-CT-06` | 5 | 전환 트랜잭션 | B19 B21 B23 B26 | **AC 5개 예외**: `AC-ACC-06`·`AC-CT-06`은 같은 규칙("어느 Lead에서 왔는지")을 두 엔티티에 쓴 것. 기존 Account 조회는 B11을 거친다(`AC-LD-19` 검증은 B12) |
| B18 | `[BE] 전환 시 Lead 활동을 새 Contact로 이동` | `AC-LD-21` `AC-AT-13` | 2 | 전환 트랜잭션 | B29 | 두 ID는 같은 규칙을 02·05가 각각 적은 것. `AC-AT-13` 검증 방법(3건 이동, 총 건수 불변)을 자동 테스트로 |

#### `[FE]` (`priority:high`)

| # | 제목 | 인용 AC | AC 수 | 선행 | 비고 |
|---|---|---|---|---|---|
| F06 | `[FE] Lead 목록·등록 폼` | `AC-LD-01`(FE) `02` `03` `AC-COMMON-04`(FE) | 4 | C2 F05 | |
| F07 | `[FE] Lead 상세 — 상태 변경, 활동 목록, 전환 결과 링크` | `AC-LD-05`(FE) `06` `15`(FE 링크) `20` (+ `AC-AT-15` FE 참조) | 4 | F06 F20 | 활동 목록·추가 UI는 F20 컴포넌트 사용 |
| F08 | `[FE] Lead 전환 화면과 결과 안내` | `AC-LD-10` `17` `18` `AC-ACC-07`(FE: 동일 이름 안내·기존 선택 진입점) | 4 | F07 | 기존 Account 선택 방식은 designer |

### 4.3 Epic 3. Account / Contact 관리 — `prd/03-account-contact.md`

#### `[BE]`

D3: Epic은 `medium`이지만 **Epic 4가 의존하는 생성·수정·상태 규칙 이슈(B19 B21 B22)는 `priority:high`**. 삭제 규칙(B20)은 Epic 4 선행이 아니라 Epic 값 `medium`을 유지한다. — 사용자 확인 항목 (7장 Q2)

| # | 제목 | 라벨 | 인용 AC | AC 수 | 설명 포인트 | 선행 | 비고 |
|---|---|---|---|---|---|---|---|
| B19 | `[BE] Account 생성·수정·목록 (업종 목록 검증)` | `priority:high` | `AC-ACC-01`(BE) `04`(BE) `10` `AC-COMMON-04`(Account) | 4 | 없음 | B11 | |
| B20 | `[BE] Account 삭제 규칙 (Opportunity 있으면 거부, Contact·활동 종속 삭제), 중복 허용, 상한` | `priority:medium` | `AC-ACC-05` `07`(BE) `09`(Account) | 3 | 없음 | B19 B21 B29 | |
| B21 | `[BE] Contact 생성·수정·목록, 소속 Account 고정` | `priority:high` | `AC-CT-01`(BE) `03`(BE) `04`(BE) `AC-COMMON-04`(Contact) | 4 | 없음 | B19 | 다른 작업 공간 Account 지정 거부는 B11 경유(`AC-CT-03`) |
| B22 | `[BE] Contact 재직 상태와 삭제 (주 담당자 비움, 활동 종속 삭제, 상한)` | `priority:high` | `AC-CT-08`(BE) `05` `AC-ACC-09`(Contact) | 3 | 없음 | B21 B23 B29 | `AC-OP-24`가 이 상태 값을 쓴다 |

#### `[FE]` (`priority:medium`)

| # | 제목 | 인용 AC | AC 수 | 선행 | 비고 |
|---|---|---|---|---|---|
| F09 | `[FE] Account 목록과 삭제 확인` | `AC-ACC-02` `05`(FE 확인 문구) `AC-COMMON-04`(FE) | 3 | C3 F05 | |
| F10 | `[FE] Account 등록·수정 폼 (업종 선택, 동일 이름 안내)` | `AC-ACC-01`(FE) `04`(FE) `07`(FE 등록 폼 안내) `10`(FE 목록 선택) | 4 | F09 | |
| F11 | `[FE] Account 상세 — Contact·Opportunity 목록, 활동 모아 보기, 대상 선택 추가` | `AC-ACC-03` `AC-AT-14`(FE 대상 표시) `AC-AT-16` | 3 | F09 F20 (C4 C5) | Opportunity 목록·모아 보기는 C4·C5 계약 승인 후 완성 |
| F12 | `[FE] Contact 목록·상세 (재직 상태 표시, 직접 붙은 활동)` | `AC-CT-02` `07` `AC-AT-15`(FE) `AC-COMMON-04`(FE) | 4 | C3 F05 F20 | |
| F13 | `[FE] Contact 등록·수정 폼 (소속 고정, 재직 상태)` | `AC-CT-01`(FE) `03`(FE) `04`(FE: 소속 변경 불가) `08`(FE) | 4 | F12 | |

### 4.4 Epic 4. Opportunity 단계 관리와 파이프라인 칸반 — `prd/04-opportunity-pipeline.md`

#### `[BE]` (`priority:high`)

| # | 제목 | 인용 AC | AC 수 | 설명 포인트 | 선행 | 비고 |
|---|---|---|---|---|---|---|
| B23 | `[BE] Opportunity 생성·수정 (필수값·금액·날짜 검증, 생성 단계 "발굴" 고정)` | `AC-OP-01`(BE) `02`(BE) `03` `AC-COMMON-06`(BE 정수 KRW) | 4 | 없음 | B19 B11 | 생성 시 이력 1건은 B26 규칙 |
| B24 | `[BE] 주 담당자 규칙 — Account 소속 검증, 퇴사 Contact 지정 거부, 응답에 상태 포함` | `AC-OP-04` `24` `25`(BE) | 3 | 없음 | B21 B22 B23 | 응답 형식은 C4 |
| B25 | `[BE] Opportunity 삭제(열린 건만)·목록·상한` | `AC-OP-05`(BE) `23` `AC-COMMON-04`(Opportunity) | 3 | 없음 | B23 B29 | |
| **B26** | `[BE] 단계 상태 머신 — 허용 전이 표(서버 단일 기준), 거부 사유, 단계 변경과 이력 기록의 원자성` | `AC-OP-07` `08` `11` | 3 | **상태 머신·이력 (핵심)** | B23 | 구현 시 결정할 것: 전이 표의 표현(enum 메서드·테이블·설정), 이력 기록을 같은 트랜잭션에 묶는 방법, "갈 수 있는 단계" 응답 |
| B27 | `[BE] 종료 단계 잠금, 동시 단계 변경 제어, 이력 불변` | `AC-OP-09` `10` `12` | 3 | 상태 머신·이력 | B26 | `AC-OP-10` 두 시나리오 자동 테스트 필수. 동시성 제어(낙관적 락 등)는 트러블슈팅 후보 |
| B28 | `[BE] 파이프라인 조회 — 단계별 묶음, 건수·금액 합계` | `AC-OP-21` `AC-DB-02`(같은 규칙·같은 값) | 2 | 집계 | B23 B24 | 대시보드와 집계 규칙을 공유하는 읽기 전용 엔드포인트라 분리 |

#### `[FE]` (`priority:high`)

| # | 제목 | 인용 AC | AC 수 | 선행 | 비고 |
|---|---|---|---|---|---|
| F14 | `[FE] 파이프라인 칸반 보드 (기본 진입 화면) — 열·카드·합계·종료 건·지연 표시·생성 진입점` | `AC-OP-15` `16` `19` `20` | 4 | C4 F02 F05 | |
| F15 | `[FE] 칸반 단계 변경 — 메뉴(필수)·드래그(선택), 거부 처리, 담당자 퇴사 표시` | `AC-OP-17` `18` `25`(FE 카드) | 3 | F14 | 서버의 "갈 수 있는 단계"로 버튼을 그린다(`AC-OP-07`) |
| F16 | `[FE] Opportunity 생성·수정 폼 — 주 담당자 선택(퇴사 제외), 금액 입력` | `AC-OP-01`(FE) `02`(FE) `25`(FE 교체 선택지) `AC-COMMON-06`(FE) | 4 | F14 | |
| F17 | `[FE] Opportunity 상세 — 단계 변경 UI, 실패 사유 입력, 삭제` | `AC-OP-05`(FE) `06` `14` (+ `25` FE 상세 표시) | 3 | F15 F20 | 활동 목록·추가는 F20 |
| F18 | `[FE] 단계 이력 타임라인(머문 기간)과 활동 통합 타임라인` | `AC-OP-13` `AC-AT-08` `AC-AT-06`(FE: 종료 건 활동 추가 허용) | 3 | F17 | |

### 4.5 Epic 5. 활동 기록 — `prd/05-activity.md`

#### `[BE]` (`priority:medium`)

| # | 제목 | 인용 AC | AC 수 | 설명 포인트 | 선행 | 비고 |
|---|---|---|---|---|---|---|
| B29 | `[BE] Activity 생성·수정·삭제 — 종류·대상(다형) 검증, 대상 변경 불가` | `AC-AT-01`(BE) `02` `03`(BE) | 3 | 없음 | B11 B14 B19 B21 B23 | 전환된 Lead 대상 거부 포함 |
| B30 | `[BE] 할 일 완료 전환, 종료 Opportunity 활동 허용, 대상 삭제 시 종속 삭제` | `AC-AT-04` `05` `06` | 3 | 없음 | B29 B15 B20 B22 B25 | `AC-AT-05`는 네 엔티티 삭제 경로 모두 검증 |
| B31 | `[BE] Activity 전체 목록·필터, 상한` | `AC-AT-10` `12` `AC-COMMON-04`(Activity) | 3 | 없음 | B29 | |
| B32 | `[BE] Account 활동 모아 보기와 "직접 붙은 것만" 범위 규칙` | `AC-AT-14` `15`(BE) | 2 | 없음 | B29 | 범위 규칙 한 쌍. `AC-AT-14` 검증 방법(3건/0건)을 자동 테스트로 |

#### `[FE]` (`priority:medium`)

| # | 제목 | 인용 AC | AC 수 | 선행 | 비고 |
|---|---|---|---|---|---|
| F19 | (없음 — 미완료 할 일 영역 `AC-AT-09`는 F23 대시보드 위젯에 둠) | | | | designer가 별도 화면으로 정하면 `[FE] 미완료 할 일 화면`(AC 1개)으로 분리 |
| F20 | `[FE] 활동 목록·추가 폼 공유 컴포넌트 (상세 4곳, 할 일 완료 전환)` | `AC-AT-01`(FE) `03`(FE) `04`(FE) `07` | 4 | C5 F05 | F07 F11 F12 F17이 통합. 상세 화면들보다 먼저 |

> F19 번호는 비워 둔다(분리 시 사용). 생성 시 번호는 GitHub가 매기므로 영향 없음.

### 4.6 Epic 6. 대시보드 — `prd/06-dashboard.md`

#### `[BE]` (`priority:high`)

| # | 제목 | 인용 AC | AC 수 | 설명 포인트 | 선행 | 비고 |
|---|---|---|---|---|---|---|
| **B33** | `[BE] 대시보드 요약 집계 — 단계별·전체·수주/실패·지연·미완료 할 일, 즉시 반영, 0건 처리` | `AC-DB-01` `02` `04` `07` (+ `AC-COMMON-15` BE 지연 판정 기준) | 4 | **집계 (핵심)** | B28 B31 | 구현 시 결정할 것: 매 요청 계산 vs 캐시·집계 테이블, 반영 지연 허용 여부(지연이 생기면 ADR), 지연 판정의 "오늘" 계산 위치 |
| B34 | `[BE] 수주율 계산 규칙과 집계 정합성 자동 테스트` | `AC-DB-03` `05` | 2 | 집계 | B33 B09 | `AC-DB-03` 검증 예 6가지, `AC-DB-05` (a)(b)(c)를 시드 기대값(`seed/*.md` §8)과 임의 조작 후 양쪽에서 테스트 |

#### `[FE]` (`priority:high`)

| # | 제목 | 인용 AC | AC 수 | 선행 | 비고 |
|---|---|---|---|---|---|
| F21 | `[FE] 대시보드 화면 — 단계별 차트, 수주율·기준 라벨, 전체·지연 수, 차트 토큰` | `AC-DB-08` `09` `10` `11` | 4 | C6 F05 F14 | 수주율 "계산 불가" 표시 포함(`AC-DB-03`) |
| F23 | `[FE] 대시보드 위젯 — 미완료 할 일 목록(지연·오늘 기한 강조)과 초기화 버튼 배치` | `AC-AT-09` `AC-WS-23`(버튼 위치) | 2 | F21 F04 | designer가 할 일을 별도 화면으로 정하면 F19로 이동. 배치 결정에 영향받는 부분만 모아 2개 |

### 4.7 Epic 7. 회원 계정 — `prd/07-member.md`

#### `[BE]` (`priority:medium`)

| # | 제목 | 인용 AC | AC 수 | 설명 포인트 | 선행 | 비고 |
|---|---|---|---|---|---|---|
| B35 | `[BE] 회원 가입·로그인 — 아이디 규칙·유일성, 세션 상한, 01 규칙의 회원 적용 검증` | `AC-MB-01`(BE) `02` `03`(BE) `05`(BE 검증) | 4 | 없음 | B01 B02 B07 B10 | `AC-MB-05`는 회원 계정으로 `AC-WS-12~17` `24~25` `37` 시나리오가 통과함을 테스트 |
| B36 | `[BE] 가입 남용 방지 — IP 24시간 3건, 전체 500명, 로그` | `AC-MB-06` `07` | 2 | 없음 | B35 | 값은 설정값. IP 식별은 B04와 같은 방법 |

#### `[FE]` (`priority:medium`)

| # | 제목 | 인용 AC | AC 수 | 선행 | 비고 |
|---|---|---|---|---|---|
| F22 | `[FE] 회원가입·로그인 화면 — 아이디·비밀번호 규칙 안내, 복구 없음 안내, 거부 사유 표시` | `AC-MB-01`(FE) `03`(FE 안내) `06`(FE 사유) `07`(FE 안내) | 4 | C7 F01 | |
| F24 | `[FE] 회원 진입점과 회원 표시 차이 (남은 시간 없음)` | `AC-MB-08` `04`(FE) | 2 | F01 F03 F22 | F01·F03 화면을 고치는 작업이라 분리 |

### 4.8 API 계약 작업 이슈 (docs 레포, Issue type `Task`, `area:docs`) — D8

#### 구성 제안: 공통 규약 1개 + Epic별 7개 = 8개 (추천)

| 안 | 구성 | 장점 | 단점 |
|---|---|---|---|
| **(a) 추천** | C0 공통 규약 + Epic별 C1~C7 | 검토 사이클(senior-backend 작성 → frontend 검토 → 사용자 승인)이 Epic 단위로 짧게 돌아 FE가 Epic별로 착수할 수 있다. 각 계약이 Epic의 sub-issue가 되어 Epic 진행률에 계약 승인이 포함된다. 페이지네이션·오류 형식 같은 횡단 결정을 C0에서 한 번만 한다 | 이슈 8개 |
| (b) 묶기 3개 | 인증·작업 공간 / 엔티티 CRUD 4종 / 전환·집계 | 이슈 3개, 엔티티 간 일관성 검토가 한 번에 된다 | 4종 CRUD 계약이 모두 승인될 때까지 FE 착수가 막힌다. Epic sub-issue가 안 되고(여러 Epic에 걸침) 체크리스트로만 연결 |

| # | 제목 | 상위 Epic (sub-issue) | 라벨 | 다루는 AC | 작성 순서 |
|---|---|---|---|---|---|
| C0 | `[DOCS] API 계약 공통 규약과 openapi.yaml 골격` | 없음 (횡단, Milestone만) | `area:docs` `priority:high` | `AC-COMMON-03`(만료/인증 필요 구분) `04`(페이지네이션 방식·칸반/대시보드 예외) `05`(오류 형식) `06`(금액) `09` `12` `13`(세션 보관 수단·식별자 형식) `15`(날짜·시각 형식), `AC-WS-27`, 업종 15개 값 표기(00 §4.1) | 1 |
| C1 | `[DOCS] API 계약: 세션·테스트 계정 대여·작업 공간·초기화` | E1 | `area:docs` `priority:high` | B01~B10의 엔드포인트. 만료 시각 조회(`AC-WS-29`), 가장 이른 만료 시각(`AC-WS-07`), 업종 거부 사유 구분(`AC-WS-16`) | 2 |
| C3 | `[DOCS] API 계약: Account·Contact` | E3 | `area:docs` `priority:high` | B19~B22. 삭제 거부 사유(`AC-ACC-05`), 재직 상태 값(`AC-CT-08`) | 3 (Epic 4 선행, D3와 같은 논리) |
| C4 | `[DOCS] API 계약: Opportunity·단계 전이·파이프라인` | E4 | `area:docs` `priority:high` | B23~B28. "갈 수 있는 단계" 응답(`AC-OP-07`), 거부 사유 구성(`AC-OP-08`), 종료 후 메모 수정 허용 여부(`AC-OP-09`), 주 담당자 상태 포함 방식(`AC-OP-25`) | 4 |
| C2 | `[DOCS] API 계약: Lead와 전환` | E2 | `area:docs` `priority:high` | B14~B18. 전환 요청·응답 형식, 기존 Account 식별자 전달, 부분 실패 에러 표현(02 §5) | 5 |
| C5 | `[DOCS] API 계약: Activity (필터, Account 모아 보기)` | E5 | `area:docs` `priority:medium` | B29~B32. 모아 보기 응답·페이지네이션(`AC-AT-14`), 할 일 날짜만 형식(`AC-AT-01`) | 6 |
| C6 | `[DOCS] API 계약: 대시보드 요약` | E6 | `area:docs` `priority:high` | B33~B34. "계산 불가" 표현(`AC-DB-03`) | 7 |
| C7 | `[DOCS] API 계약: 회원 가입·로그인` | E7 | `area:docs` `priority:medium` | B35~B36. 회원 세션 상한(`AC-MB-03`), 거부 사유 구분(`AC-MB-06` `07`) | 8 |

작성 순서는 BE 자연 순서(6장)와 같다. C1 승인 전에는 FE가 F01·F02 정적 부분만 할 수 있다.

#### 계약 이슈 본문 (Task 템플릿)

```
## 작업 내용
senior-backend가 PRD(와 있으면 디자인 스펙)를 보고 `api/NN-....md`와 `api/openapi.yaml`의 해당 부분을 작성한다.
frontend가 소비자 관점에서 검토한다: "이 계약으로 F.. 화면을 다 만들 수 있는가". 사용자가 최종 승인한다.
- Epic: dealtrail-crm/dealtrail-docs#..
- 소비하는 FE 이슈: dealtrail-crm/dealtrail-web#.., ...
- 구현하는 BE 이슈: dealtrail-crm/dealtrail-api#.., ...

## 완료 조건
- [ ] `api/NN-....md`: API별 목적, 요청/응답, 비즈니스 규칙, 에러 케이스, 동시성 주의점 (HANDOFF 2장 형식)
- [ ] `api/openapi.yaml` 갱신 (frontend 타입 생성·목 용)
- [ ] 위 "다루는 AC"의 모든 ID가 어느 엔드포인트에서 성립하는지 문서에 표시됨
- [ ] frontend 검토 결과가 이 이슈 코멘트로 남음 (막히는 화면 없음)
- [ ] 사용자 승인 코멘트 → 닫기

## 관련 문서
- PRD: prd/0N-....md (AC-...)
- 디자인: design/... (있으면)
```

커밋은 docs 레포 PR, `docs(docs): API 계약 ... 작성 (#C번호)`.

#### 제목 접두어 제안

HANDOFF 규칙 "접두어 = 코드가 바뀌는 레포"를 따르면 docs 레포는 **`[DOCS]`**가 맞다 (추천). 대안 `[API]`는 "api 레포"와 혼동되고(`[BE]`가 이미 api 레포), 디자인 문서 이슈가 생기면 또 다른 접두어가 필요해진다. `[DOCS]` 하나로 두고 산출물 종류는 제목 본문("API 계약:", "디자인:")과 라벨(`area:docs` / `area:design`)로 구분한다. — 사용자 확인 항목 (7장 Q1)

`.github` 레포 Task·Feature 템플릿 주석 수정안 (승인 후 PM이 커밋):

```
제목 규칙: 이슈가 속한 레포에 따라 접두어를 붙인다.
  [FE] web 레포 / [BE] api 레포 / [INFRA] infra 레포 / [DOCS] docs 레포 (API 계약·디자인 등 문서 작업)
  예: [INFRA] GitHub Actions CI 워크플로 추가 / [DOCS] API 계약: Lead와 전환
```

### 4.9 인프라 (infra 레포) — **infra 결정 대기**

이 절은 비워 둔다 (D6). infra 에이전트가 배포 방식(EC2+Compose vs ECS) 결정안을 만드는 중이며, 결정 후 인프라 이슈 목록을 이 절에 채운다. 이전 초안의 #29~#31(배포 방식 비교, 컨테이너·Compose, CI)도 그때 함께 정리한다.

- **I-d(정리 배치 외부 트리거)는 삭제**: 정리 배치는 앱 내 스케줄러(Spring `@Scheduled`)로 확정 (B13).
- **규칙 (D7)**: 인프라 이슈는 Epic 없이 **Milestone만** 연결한다. 대신 각 이슈 본문의 "관련 문서"(Task 템플릿 항목)에 다음을 넣는다.
  - 근거 HANDOFF 절 (예: 1장 "인프라 원칙", 3장 "레포 구성")
  - 지원하는 PRD AC ID (예: 방문자 IP 식별 → `AC-WS-06` `AC-MB-06`; 배치 단일 실행 전제 → `AC-WS-36`)
  - 관련 ADR 링크 (api 레포 `docs/adr/`, 생기면)

---

## 5. 이슈 수 집계

| 레포 | 수 | 내역 |
|---|---|---|
| docs | 15 | Epic E1~E7 (7) + API 계약 C0~C7 (8) |
| api (`[BE]`) | 36 | B01~B36 |
| web (`[FE]`) | 23 | F01~F18, F20~F24 (F19 예비) |
| infra (`[INFRA]`) | 대기 | infra 결정 후 |
| **합계 (지금 생성)** | **74** | Milestone 4개, 라벨 `area:docs` 4개 별도 |

Epic별: E1 BE 13 · FE 5 · C 1 / E2 BE 5 · FE 3 · C 1 / E3 BE 4 · FE 5 · C 1 / E4 BE 6 · FE 5 · C 1 / E5 BE 4 · FE 1 · C 1 / E6 BE 2 · FE 2 · C 1 / E7 BE 2 · FE 2 · C 1.

AC 수 예외(2~4 밖): 1개 없음. 5개 — B13(ADR 범위를 하나로), B17(같은 규칙 두 엔티티). 7개 — B12(교차 검증 한 시나리오). 2개 이슈는 비고에 이유를 적었다.

> 1인 백엔드에 BE 36개는 많다. 구현하면서 "같은 PR로 끝나는 이슈"가 보이면 사용자가 요청할 때 PM이 합친다 (지금은 확정하지 않는다).

---

## 6. 백엔드 이슈의 자연스러운 순서 (참고, 사용자가 구현하므로 강제 아님)

1. B01 세션 → B02 비밀번호 → B03 대여 시작 → B04 경쟁 · B05 로그인 규칙 · B06 만료 거부 (여기까지 "로그인되는 빈 앱")
2. B11 격리 메커니즘 (모든 CRUD의 전제)
3. 엔티티: B14 B15 Lead / B19 B21 B22 B20 Account·Contact / B23 B24 B25 Opportunity / B26 B27 상태 머신 / B29 B30 B31 B32 Activity
4. B07 작업 공간 생성 → B08 적재기 → B09 데이터 3종 → B10 초기화 / B28 파이프라인 조회
5. B17 생성물 규칙 → B18 활동 이동 → B16 전환 트랜잭션 / B33 집계 → B34 수주율·정합성
6. B12 격리 교차 검증 · B13 정리 배치 · B35 B36 회원

계약은 C0 → C1 → C3 → C4 → C2 → C5 → C6 → C7 순으로 BE 순서를 앞서 간다.

---

## 7. 사용자 결정 반영 상태와 남은 확인 항목

### 반영된 결정

| # | 결정 | 반영 위치 |
|---|---|---|
| D1 | Epic 우선순위 초안 그대로 | 2.1 |
| D2 | 대안 B(AC 2~4개). 포인트 혼합 금지, 핵심 이슈 표시, 예외 이유, 선행 표시 | 3장, 4장 |
| D3 | Account·Contact BE를 `priority:high` | 4.3 (B19 B21 B22) |
| D4 | Epic에 area 라벨 | 2.1 (7개 모두 api·web·docs) |
| D5 | Milestone 기한 비움 | 1장 |
| D6 | 배포 의존 인프라 이슈는 결정 후. 절은 "infra 결정 대기" | 4.9 |
| D7 | 인프라 이슈는 Epic 없이 Milestone만 + 관련 문서 규칙 | 4.9 |
| D8 | `area:docs` 신설, API 계약 이슈 8개, `[DOCS]` 접두어, 템플릿 주석 수정안 | 0장, 4.8 |
| D9 | `prd/README.md`·`prd/seed/README.md` 상태 문구 "확정" | 로컬 수정 완료, 8장 6단계에서 커밋 |
| 정리 배치 | 앱 내 스케줄러 확정, I-d 삭제, B13 "구현 시 결정할 것" | 4.1.1, 4.9 |

### 아직 사용자 확인이 필요한 것

| # | 항목 | PM 추천 |
|---|---|---|
| Q1 | docs 레포 이슈 접두어 `[DOCS]` vs `[API]` | `[DOCS]` (4.8) |
| Q2 | Epic 3 BE 4개 중 B20(Account 삭제 규칙)만 `medium` 유지 | 유지. Epic 4 선행이 아니다. 전부 `high`로 통일해도 무방 |
| Q3 | API 계약 구성 (a) 8개 vs (b) 3개 | (a) |
| Q4 | `AC-COMMON-*` 전담 이슈(B01 B02 F02 F03 F05)를 Epic 1 하위에 두는 것 | Epic 1 하위. 대안은 Epic 없이 Milestone만(인프라처럼) |
| Q5 | AC 수 예외 3건(B12 7개, B13·B17 5개) | 비고의 이유대로 허용 |

---

## 8. 생성 순서와 도구 (승인 후)

사용자가 **gh CLI**를 설치해 `gh issue create --project "Dealtrail Issue Tracker"`로 org Projects 보드에 바로 넣기로 했다. gh에 없는 기능(Issue type, 레포 간 sub-issue)은 GitHub MCP 또는 `gh api`로 보완한다.

### 8.1 도구 분담

| 작업 | 도구 | 명령·호출 | 확실성 |
|---|---|---|---|
| 토큰 권한 확인 | gh | `gh auth status`. Projects 조작에는 `project` scope 필요 → 없으면 `gh auth refresh -s project` | **확인 필요** (org Projects v2에 `--project`가 토큰 scope를 요구하는 것으로 알고 있음) |
| 라벨 `area:docs` 생성 (4 레포) | gh | `gh label create "area:docs" --repo dealtrail-crm/<repo> --description "문서 작업 (PRD·API 계약·디자인 문서)" --color <기존 area:* 와 같은 계열>` — 색은 `gh label list --repo ...`로 기존 값을 보고 맞춤 | 확실 |
| Milestone 생성 (4 레포) | gh api | `gh api repos/dealtrail-crm/<repo>/milestones -f title="v0.1 MVP" -f description="..."` (gh에 milestone 서브커맨드 없음) | 확실 |
| 이슈 생성 + 라벨 + Milestone + Projects 보드 | gh | `gh issue create --repo dealtrail-crm/<repo> --title "..." --body-file <파일> --label "area:api" --label "priority:high" --milestone "v0.1 MVP" --project "Dealtrail Issue Tracker"` | `--project`는 프로젝트 **제목**으로 지정. org 프로젝트 매칭 **확인 필요**. 실패하면 `gh project item-add <번호> --owner dealtrail-crm --url <이슈 URL>` (번호는 `gh project list --owner dealtrail-crm`) |
| Issue type 지정 | GitHub MCP `issue_write` (method `update`, `type`) | 템플릿 frontmatter `type:`은 웹 UI 생성에만 적용되고 CLI·API 생성에는 적용되지 않는 것으로 알고 있음 → 생성 후 MCP로 지정 | `gh issue create`에 type 플래그가 있는지 **확인 필요** (`gh issue create --help`). 있으면 gh 한 번으로 끝. 대안: `gh api graphql` `updateIssue(issueTypeId)` |
| Epic ↔ 작업 이슈 sub-issue 연결 (레포 간) | GitHub MCP `issue_write`(`parent_owner`/`parent_repo`/`parent_issue_number`) 또는 `sub_issue_write`(method `add`) | type 지정과 **같은 `issue_write` update 호출**에 parent를 함께 넣으면 이슈당 보완 호출이 1번으로 끝난다 | 레포 간 가능 여부 **첫 Epic에서 확인**. 대안: `gh api repos/dealtrail-crm/dealtrail-docs/issues/<Epic번호>/sub_issues -F sub_issue_id=<작업 이슈의 database id>` (id는 `gh api repos/.../issues/<n> --jq .id`). 전부 안 되면 Epic 본문 체크리스트 |
| 계약 이슈 ↔ Epic sub-issue (같은 레포) | 위와 같음 | docs 레포 안이라 레포 간 문제 없음 | 확실 |
| Epic 본문의 작업 이슈 번호 채우기 | GitHub MCP `issue_write` (update, body) | 작업 이슈가 생긴 뒤 Epic 본문 체크리스트에 번호 기입 | 확실 |

이슈 본문은 PM이 이 초안에서 이슈별 `.md` 파일로 뽑아 scratch 폴더에 둔다(`--body-file`). 커밋하지 않는다.

### 8.2 순서

1. `gh auth status` → scope 확인. 4개 레포에 `area:docs` 라벨, `v0.1 MVP` Milestone 생성.
2. **C0** 공통 계약 이슈 생성 (docs, Epic 없음) → MCP로 type `Task` 지정.
3. **E1** Epic 생성 (docs, `area:api` `area:web` `area:docs` `priority:high`) → type `Epic`.
   - **C1** 생성 → E1의 sub-issue (같은 레포, 연결 확인).
   - **B01** 생성 (api) → **E1의 sub-issue로 레포 간 연결 시도** → 결과 기록. 성공이면 이후 전부 sub-issue, 실패면 Epic 본문 체크리스트.
   - 나머지 B02~B13, F01~F05 생성·연결. Epic 본문에 핵심 이슈(B04 B08 B11 B13) 번호 기입.
4. E2~E7과 C2~C7, 작업 이슈를 같은 방식으로 생성. 선행 이슈 번호는 생성 순서상 아직 없을 수 있으므로 **각 Epic의 이슈를 모두 만든 뒤 본문의 "선행: B.." 참조를 GitHub 번호로 치환**하는 보완 패스를 한 번 돈다.
5. 인프라 이슈는 infra 결정 후 (4.9).
6. HANDOFF 갱신·커밋: 4장 "세팅 시 확인 필요" 두 항목 결과(sub-issue 레포 간 가능 여부, Projects는 gh CLI), 8장 미결정에서 두 항목 제거, 9장 첫 항목을 "designer 화면 흐름 작업 + senior-backend C0·C1 계약 작성"으로. `prd/README.md`·`prd/seed/README.md` 상태 문구와 함께 커밋: `docs(docs): PRD 상태를 확정으로 갱신하고 이슈 세팅 결과 반영 (#E1번호)`.
7. `.github` 레포 템플릿 주석에 `[DOCS]` 추가 커밋 (4.8 수정안).
