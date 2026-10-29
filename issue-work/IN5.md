## 작업 내용

운영 서버를 Terraform으로 만든다: VPC·서브넷, 보안 그룹(인바운드 80·443만), EC2 t4g.small(서울), 고정 IP(Elastic IP), SSM으로 접속(SSH 포트 없음), 매일 EBS 스냅샷 7일 보관(DLM). NAT Gateway는 두지 않는다(비용).

- 각 리소스가 무엇이고 왜 필요한지 한 줄 설명을 코드 주석과 학습 가이드에 둔다
- plan 설명 후 사용자 승인 뒤 apply

- Epic: 없음 (인프라 이슈는 Milestone만 연결한다)
- 선행: {{IN4}}
- 권장 순서: {{IN0}} → {{IN1}} → {{IN3}} → {{IN2}} → {{IN4}} → {{IN5}} → {{IN6}} → {{IN7}}

## 완료 조건

- [ ] SSH 포트를 열지 않고 SSM Session Manager로 접속된다 (두 OS 명령 제시)
- [ ] 보안 그룹 인바운드는 80·443만이다
- [ ] 일일 스냅샷이 생성되고 7일 뒤 삭제되는 정책이 적용되어 있다
- [ ] NAT Gateway가 없다. 예상 월 비용(EC2·EBS·EIP·스냅샷)이 PR과 README 비용표에 표시된다
- [ ] 해당 **학습 가이드**(infra 레포 `docs/learning/NNNN-주제.md`)를 작성·갱신하고 `docs/learning/README.md` 목록에 추가한다. 내용은 `.claude/agents/infra.md` "학습 가이드" 절(개념 / 결정과 이유 / 실제 구성 읽기 / 직접 해 보기(PowerShell·zsh) / 실수와 함정 / 점검 질문)을 따른다
- [ ] 변경에 따른 예상 월 비용을 PR에 적는다 (비용 변화가 없으면 "없음")

## 관련 문서

- HANDOFF: 1장 "인프라 구성", 2장 에이전트별 원칙 (infra)
- 지원하는 PRD AC: `AC-WS-06` `AC-MB-06` (80·443만 열어 프록시 경유 보장)
- 관련 ADR: api 레포 `docs/adr/` (생기면 링크)
