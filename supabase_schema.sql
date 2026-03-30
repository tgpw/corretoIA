-- CorretoIA - Arquitetura de atividade-modelo estruturada
-- Execute no SQL Editor do Supabase.

create table if not exists atividades_modelo (
  id bigint primary key,
  modulo text not null,
  disciplina text not null,
  tipo text not null,
  titulo text not null,
  modo_avaliacao text not null check (modo_avaliacao in ('rubrica_criterios','questoes_respostas','avaliacao_orientada')),
  peso_total numeric not null default 10,
  instrucoes text,
  ativo boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists atividade_criterios (
  id bigint primary key,
  atividade_modelo_id bigint not null references atividades_modelo(id) on delete cascade,
  nome_criterio text not null,
  peso_maximo numeric not null default 1,
  descricao_esperado text,
  niveis text,
  observacoes text,
  created_at timestamptz not null default now()
);

create table if not exists atividade_questoes (
  id bigint primary key,
  atividade_modelo_id bigint not null references atividades_modelo(id) on delete cascade,
  numero_questao text not null,
  resposta_esperada text,
  palavras_chave text,
  pontuacao_maxima numeric not null default 1,
  tipo_questao text,
  created_at timestamptz not null default now()
);

create table if not exists atividade_aspectos (
  id bigint primary key,
  atividade_modelo_id bigint not null references atividades_modelo(id) on delete cascade,
  aspecto text not null,
  peso numeric not null default 1,
  deve_aparecer text,
  falhas_comuns text,
  created_at timestamptz not null default now()
);

create table if not exists correcoes (
  id text primary key,
  atividade_modelo_id bigint references atividades_modelo(id),
  modulo text not null,
  disciplina text not null,
  tipo text not null,
  nome_aluno text,
  arquivo_nome text,
  status_correcao text not null default 'ok' check (status_correcao in ('ok','revisao')),
  nota_numerica numeric,
  nota_final text,
  feedback text,
  memoria_calculo text,
  resultado_json jsonb,
  created_at timestamptz not null default now()
);

create table if not exists correcoes_criterios (
  id text primary key,
  correcao_id text not null references correcoes(id) on delete cascade,
  label text not null,
  esperado text,
  entregue text,
  peso_max numeric,
  desconto numeric,
  nota_crit numeric,
  motivo text,
  status_item text not null default 'ok' check (status_item in ('ok','revisao')),
  created_at timestamptz not null default now()
);

create index if not exists idx_atividades_modelo_lookup on atividades_modelo (modulo, disciplina, tipo, ativo);
create index if not exists idx_correcoes_lookup on correcoes (modulo, disciplina, tipo, created_at desc);
create index if not exists idx_correcoes_modelo on correcoes (atividade_modelo_id);
