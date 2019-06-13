%%load
cd('C:\Users\Flávia\Google Drive\00 PUC BI MASTER\06 - LF\Projeto final')
filename = 'C:\Users\Flávia\Google Drive\00 PUC BI MASTER\06 - LF\Projeto final\Mall_Customers.csv';
delimiter = ',';
startRow = 2;
fileID = fopen(filename,'r');
formatSpec = '%f%C%f%f%f%[^\n\r]';
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);
MallCustomers = table(dataArray{1:end-1}, 'VariableNames', {'CUSTOMERID','GENDER','AGE','ANNUALINCOMEK','SPENDINGSCORE1100'});
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

idadeErenda = MallCustomers(:,3:4) %idade e renda
ScoreOriginal = MallCustomers(:,5) %score original
gender = MallCustomers(:,2:2)%genero

%transformando tudo em array - necessário para a função
idadeErenda = table2array(idadeErenda)
ScoreOriginal = table2array(ScoreOriginal)
gender = table2array(gender)

%comando double retorna 2 para homem e 1 para mulher. A conta abaixo é para
%binarizar invertendo 1 = mulher e 0 = homem
gender = double(ismember(gender, 'Female'))

%%base sem o score original, so os inputs (idade e renda e genero)
clientes = [idadeErenda, gender]


%Importar o Sistema Fuzzy - regras mais gerais
sistemaProjeto = readfis('Projeto.fis');

%Regra de Wang-Mendel
Resultados_originais = [clientes,ScoreOriginal(:,1)]
sistema_projeto_vazio = sistemaProjeto
sistema_projeto_vazio.rule = [];
[regras] = ExtractWangMendelRules(sistema_projeto_vazio, Resultados_originais);
disp(showrule(regras))


%Aplicar o modelo com regras gerais
Score = evalfis(sistemaProjeto, clientes);
Resultados = table(clientes(:,1), clientes(:,2), clientes(:,3), Score, ScoreOriginal(:,1), 'VariableNames', {'AGE';'ANNUALINCOMEK';'GENDER';'SPENDINGSCORE1100';'SPENDINGSCOREORIGINAL'});
disp(Resultados)


%Importar o Sistema Fuzzy - regras mais elaboradas
sistemaProjeto2 = readfis('Projeto2.fis');

%Aplicar o modelo com regras gerais
Score2 = evalfis(sistemaProjeto2, clientes);
Resultados2 = table(clientes(:,1), clientes(:,2), clientes(:,3), Score2, ScoreOriginal(:,1), 'VariableNames', {'AGE';'ANNUALINCOMEK';'GENDER';'SPENDINGSCORE1100';'SPENDINGSCOREORIGINAL'});
disp(Resultados2)

