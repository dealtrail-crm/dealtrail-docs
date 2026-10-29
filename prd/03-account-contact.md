# 03. Account / Contact 관리

| 항목 | 값 |
|---|---|
| Epic | Epic 2 (Opportunity 연결 규칙은 Epic 3, 활동 부분은 Epic 5) |
| 우선순위 | `priority:high` (Epic 3·4의 선행) |
| 관련 설명 포인트 | (직접 해당 없음) 작업 공간 격리가 적용되는 기본 CRUD |
| 선행 | Epic 1 (01 작업 공간). 02 Lead 전환(Epic 4)과 상호 참조 |
| TBD | 없음 |

## 1. 목적

Account(거래 대상 회사)와 Contact(그 회사의 담당자)는 Opportunity가 매달리는 기준 데이터다. 이 기능은 화려할 필요가 없고, **Lead 전환으로 만들어진 것과 직접 만든 것이 같은 방식으로 관리**되면 된다. 포트폴리오에서는 "기본 CRUD도 격리·검증 규칙을 일관되게 지킨다"를 보여 준다.

## 2. 유저 스토리

- US-ACC-1. 영업 담당자로서, 거래처 목록을 보고 거래처 하나를 열어 담당자와 진행 중인 영업 건을 한눈에 보고 싶다. 거래처 단위로 상황을 파악하기 위해.
- US-ACC-2. 영업 담당자로서, Lead 전환을 거치지 않고도 거래처와 담당자를 직접 등록하고 싶다. 이미 아는 거래처를 바로 넣기 위해.
- US-ACC-3. 영업 담당자로서, 담당자 정보를 고치고 퇴사한 담당자를 표시하고 싶다. 담당자 변동을 반영하면서 과거 기록은 그대로 두기 위해.
- US-ACC-6. 영업 담당자로서, 주 담당자가 퇴사한 영업 건을 알아보고 같은 거래처의 다른 담당자로 바꾸고 싶다. 연락할 사람이 없는 영업 건을 놓치지 않기 위해.
- US-ACC-4. 영업 담당자로서, 영업 건이 걸려 있는 거래처를 실수로 지우지 않길 원한다. 진행 중인 데이터가 고아가 되지 않도록.
- US-ACC-5. 영업 담당자로서, 거래처 하나를 열면 그 거래처와 담당자·영업 건에 남긴 활동을 한 곳에서 모아 보고 싶다. 고객과의 접점 전체를 거래처 단위로 파악하기 위해.

## 3. 인수조건

### 3.1 Account

- [ ] `AC-ACC-01` [공통] Account는 다음 정보를 가진다: 회사명(필수), 업종(선택, `00-overview.md` 4.1의 업종 목록 15개 중 하나), 웹사이트, 전화번호, 주소(한 줄), 메모, 생성 시각. 세부는 API 계약에서 확정한다.
- [ ] `AC-ACC-02` [FE] Account 목록은 회사명 검색이 되고, 각 행에 업종, 담당자 수, 열린 Opportunity 수를 보여 준다. 담당자 수는 **재직 중인 Contact만** 센다(`AC-CT-08`). 퇴사 Contact는 Account 상세의 Contact 목록(`AC-ACC-03`)에서 상태와 함께 보인다.
- [ ] `AC-ACC-03` [FE] Account 상세는 기본 정보, 소속 Contact 목록(재직 중·퇴사 모두, 상태 표시 포함), 연결된 Opportunity 목록(단계·금액 포함), 활동 목록을 보여 준다. 활동 목록은 **모아 보기**다: 그 Account에 직접 붙은 활동, 소속 Contact에 붙은 활동, 연결된 Opportunity에 붙은 활동을 하나의 최신순 목록으로 보이고, 각 항목에 어느 대상(Account 자신 / 어느 Contact / 어느 Opportunity)에 붙은 활동인지 표시한다. 범위 규칙은 `05-activity.md` `AC-AT-14`를 따른다. 이 화면에서 새 활동을 추가할 때는 대상을 고른다: Account 자신(기본값), 소속 Contact 중 하나, 연결된 Opportunity 중 하나. 선택지는 이 셋으로 한정된다(FE 선택지 조건, `AC-AT-16`).
- [ ] `AC-ACC-04` [공통] Account를 직접 생성·수정할 수 있다. 회사명이 비면 거부된다.
- [ ] `AC-ACC-05` [BE] 연결된 Opportunity가 하나라도 있는 Account는 삭제할 수 없고, 거부 사유에 "연결된 Opportunity가 있음"이 포함된다. Contact만 있는 Account를 삭제하면 소속 Contact도 함께 삭제되고, Account에 직접 붙은 활동과 함께 삭제되는 Contact에 붙은 활동도 모두 삭제된다(`05-activity.md` `AC-AT-05`). (삭제 정책은 FE가 삭제 전 확인 문구에 그대로 표시한다)
- [ ] `AC-ACC-06` [BE] Lead 전환의 "새 Account 만들기"로 만들어진 Account는 "어느 Lead에서 왔는지"를 알 수 있다. 직접 만든 Account는 그 정보가 비어 있다. Lead 전환에서 기존 Account를 선택해도 그 Account의 이 정보는 바뀌지 않는다 (`02-lead.md` `AC-LD-11`).
- [ ] `AC-ACC-07` [공통] 같은 작업 공간 안에서 회사명이 중복되는 Account 생성은 **허용**한다 (MVP에서는 자동 중복 감지 없음). 직접 생성과 Lead 전환의 "새 Account 만들기" 모두 같다 (`02-lead.md` §4). 단, FE는 같은 이름의 Account가 있으면 등록 폼에서는 안내만 하고 저장을 막지 않으며, Lead 전환 화면(`02-lead.md` `AC-LD-10`)에서는 안내와 함께 그 Account를 "기존 Account 선택"으로 바꾸는 진입점을 보여 주되 새로 만들기를 유지하면 전환을 막지 않는다.

### 3.2 Contact

- [ ] `AC-CT-01` [공통] Contact는 다음 정보를 가진다: 이름(필수), 소속 Account(필수, 생성 후 변경 불가 `AC-CT-04`), 상태(재직 중 / 퇴사, 필수, 기본 "재직 중", `AC-CT-08`), 이메일, 전화번호, 직함, 메모, 생성 시각.
- [ ] `AC-CT-02` [FE] Contact 목록은 이름·소속 회사명 검색이 되고, 각 행에 소속 Account 링크와 상태(재직 중 / 퇴사)가 있다.
- [ ] `AC-CT-03` [공통] Contact를 직접 생성·수정할 수 있다. 소속 Account는 같은 작업 공간의 Account만 선택 가능하다. 다른 작업 공간의 Account 식별자를 넣으면 `AC-COMMON-02`에 따라 "존재하지 않음"으로 거부된다.
- [ ] `AC-CT-04` [공통] Contact의 소속 Account는 생성 후 **바꿀 수 없다**. 소속 Account를 바꾸려는 수정 요청은 거부된다(`AC-COMMON-05` 형식). 담당자의 이직은 새 Account 아래에 Contact를 **새로 만들어** 표현하고, 이전 Contact와 그에 붙은 활동·주 담당자 연결은 원래 Account에 그대로 남는다(이전 Contact는 필요하면 "퇴사"로 표시한다, `AC-CT-08`). 따라서 Opportunity의 주 담당자는 항상 그 Opportunity의 Account 소속이다(`04-opportunity-pipeline.md` `AC-OP-04`). 잘못된 Account에 Contact를 만든 입력 실수는 삭제 후 재생성으로 바로잡는다.
- [ ] `AC-CT-05` [BE] Contact 삭제 시, 그 Contact를 주 담당자로 둔 Opportunity는 삭제되지 않고 주 담당자가 비워진다. 그 Contact에 붙은 활동은 함께 삭제된다(`05-activity.md` `AC-AT-05`).
- [ ] `AC-CT-06` [BE] Lead 전환으로 만들어진 Contact는 "어느 Lead에서 왔는지"를 알 수 있다. 그 Lead에 붙어 있던 활동은 전환 시 이 Contact로 옮겨진다(`02-lead.md` `AC-LD-21`, `05-activity.md` `AC-AT-13`).
- [ ] `AC-CT-07` [FE] Contact 상세는 기본 정보, 상태(재직 중 / 퇴사), 소속 Account 링크, 그 Contact에 **직접 붙은** 활동 목록(최신순)을 보여 주고, 그 자리에서 새 활동을 추가할 수 있다(`05-activity.md` `AC-AT-07` `AC-AT-15`). Contact 상세에는 모아 보기가 없다.
- [ ] `AC-CT-08` [공통] Contact는 상태 "재직 중"(기본) / "퇴사" 둘 중 하나를 가진다. 두 값 사이는 Contact 수정으로 어느 방향으로든 바꿀 수 있다. 상태를 바꿔도 그 Contact에 붙은 활동과 주 담당자 연결은 그대로다. 퇴사 Contact에도 활동을 새로 추가·수정·삭제할 수 있다(Contact 상세의 추가 UI는 그대로, Account 상세 선택지에도 퇴사 상태 표시와 함께 포함, `05-activity.md` `AC-AT-16`). 퇴사 표시가 막는 것은 Opportunity의 주 담당자로 **새로 지정**하는 것 하나뿐이다. 퇴사 Contact는 Opportunity의 주 담당자로 새로 지정할 수 없고, 이미 지정된 건은 유지되며 자동 해제·교체는 없다(`04-opportunity-pipeline.md` `AC-OP-24` `AC-OP-25`). 두 값 밖의 상태는 `AC-COMMON-05` 형식으로 거부된다.

### 3.3 공통

- [ ] `AC-ACC-08` [BE] Account·Contact 모두 `AC-COMMON-01~05`를 만족한다. `AC-WS-26` 검증에 포함된다.
- [ ] `AC-ACC-09` [BE] 작업 공간당 Account·Contact 각 200건(`01-trial-workspace.md` `AC-WS-37`)을 넘는 생성은 거부된다.
- [ ] `AC-ACC-10` [BE] Account 업종에 목록 밖의 값을 넣으면 `AC-COMMON-05` 형식으로 거부된다. FE는 업종을 자유 입력이 아니라 목록에서 고르게 한다.
- [ ] `AC-ACC-11` [BE] 예시 데이터로 적재된 Account는 모두 업종 값이 채워져 있다. 값은 고객사의 산업을 따르며 작업 공간 업종과 같을 필요가 없다 (`01-trial-workspace.md` 3.4.1).

## 4. 제외 범위

- Account 계층(모회사·자회사), Account 간 관계
- Contact 역할(결정권자·실무자 등) 분류, 한 Contact가 여러 Account에 소속
- Contact의 소속 Account 변경 (이직은 새 Contact 생성으로 표현, 입력 실수는 삭제 후 재생성, `AC-CT-04`)
- Contact 퇴사 시 주 담당자 자동 해제·자동 교체, 퇴사 Contact의 Opportunity 일괄 이관 (`AC-CT-08`)
- 재직 중·퇴사 외의 상태(휴직 등), 퇴사일 기록
- 자동 중복 감지·병합 (Lead 전환에서 "새 Account 만들기"를 유지해 같은 회사의 Account가 거듭 생기는 경우 포함, `02-lead.md` §4)
- 파일 첨부, 명함 스캔
- 대량 가져오기(CSV)
- Account·Contact 삭제 복구

## 5. 의존성 / 열린 질문

- Account 상세의 Opportunity 목록은 04가 선행되어야 의미가 있다. FE 작업은 04 목록 조회와 묶어 진행할 수 있다.
- Account 상세의 활동 모아 보기(`AC-ACC-03`)는 05 `AC-AT-14` 조회가 선행되어야 한다. 응답 형식·페이지네이션은 API 계약에서 정한다.
- Account·Contact 상세의 활동 목록과 추가 UI의 배치(탭·패널 등), Account 상세 활동 추가의 대상 선택 UI, Contact 상세에 기본 정보·활동 외에 무엇을 더 보일지, Contact 목록·상세의 퇴사 상태 표시 방식은 designer가 정한다.
