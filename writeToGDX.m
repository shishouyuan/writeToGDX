function r= writeToGDX(filename,param)
%A MATLAB function simplifies the work of writing data into GAMS GDX file. 
%һ�����Լ�д��GAMS GDX�ļ�������MATLAB������
%
%���ߣ�ʷ��Բ @ ��������ѧ
%���䣺shishouyuan@outlook.com
%
%Author��Shi Shouyuan @ South China University of Technology
%E-mail��shishouyuan@outlook.com
%
%Parameter Discription��
%filename:
%The target GDX file name.
%param��
%Format 1�� A char array, gives the prefix that indicates which variables in MATLAB workspace need to be written to GDX file.
%Format 2��A structure, contains all parameters need to be written to GDX file.
%r:
%Return the code for GAMS to load these parameters just written to GDX file, for example��
%```
%    $GDXIN abc.gdx
%    $Load Power=Power
%    $Load Power2=Power2
%    $GDXIN
%    ;
%```
%
%Usage of the 2 Formats��
%Format 1: Prefixing
%Name all the parameters need to be written to GDX file as follow:
%```
%prefix_dimension_nameInGDX
%```
%Example��
%```
%prefix='GDX';
%GDX_2_Power=[1,2;3,4];
%GDX_2_Power2=[1,2;3,4];
%writeToGDX('abc.gdx',prefix)
%```
%Format 2: Structuring
%Put every parameter need to be written to GDX file into a structure, with each element named as follow:
%```
%nameInGDX_dimension
%```
%Example��
%```
%p.Power1_0=1;
%p.Power2_2=[1,2;3,4];
%writeToGDX('abc.gdx',p)
%```
%
%r= writeToGDX(filename,param)
%����˵����
%filename:
%Ҫд���GDX�ļ���
%param��
%��ʽһ������ǰ׺��������ʶҪд��ı���
%��ʽ������������Ҫд��ı����Ľṹ��
%
%r:
%����GAMS���ڵ������������磺
%```
%    $GDXIN abc.gdx
%    $Load Power=Power
%    $Load Power2=Power2
%    $GDXIN
%    ;
%```
%2�ָ�ʽ��ʹ�÷�����
%��ʽһ��ǰ׺��ʽ
%��Ҫд��GDX�ı�����������ĸ�ʽ����·������
%```
%prefix_ά��_GDX�еĲ�����
%```
%���ӣ�
%```
%prefix='GDX';
%GDX_2_Power=[1,2;3,4];
%GDX_2_Power2=[1,2;3,4];
%writeToGDX('abc.gdx',prefix)
%```
%��ʽ�����ṹ����ʽ
%��Ҫд��GDX�ı�������һ���ṹ���У��ṹ��������ĸ�ʽ��������
%```
%GDX�еĲ�����_ά��
%```
%���ӣ�
%```
%p.Power1_0=1;
%p.Power2_2=[1,2;3,4];
%writeToGDX('abc.gdx',p)
%```

%�޸�ʱ�䣺2018-6-6
%�����˽ṹ�������ʽ
%�����˲������к��»��߲�����ʶ������������
%����ʱ�䣺2018-6-5

writeEval=['wgdx(''',filename,''''];
r=['$GDXIN ', filename,char(13,10)'];
if(isstruct(param))
    varNames=fieldnames(param);
    varN=size(varNames);
    varRegex='(.*)_(\d+)$';
    parts=regexp(varNames,varRegex,'tokens');
    vars=cell(varN);
    for ii=1:varN
        vars{ii}.type='parameter';
        vars{ii}.form='full';
        vars{ii}.name=parts{ii}{1}{1};
        vars{ii}.dim=str2num(parts{ii}{1}{2});
        vars{ii}.val=getfield(param,varNames{ii});
        writeEval=[writeEval,', vars{',num2str(ii),'}'];
        r=[r,'$Load ',vars{ii}.name,'=',vars{ii}.name,char(13,10)'];
    end
else
    varRegex=['^', param, '_(\d+)_(.*)'];
    findVarEval=['who(''-regexp'',''' varRegex,''')'];
    varNames=evalin('caller',findVarEval);
    varN=size(varNames);
    vars=cell(varN);    
    parts=regexp(varNames,varRegex,'tokens');
    for ii=1:varN
        vars{ii}.type='parameter';
        vars{ii}.form='full';
        vars{ii}.dim=str2num(parts{ii}{1}{1});
        vars{ii}.name=parts{ii}{1}{2};
        vars{ii}.val=evalin('caller',varNames{ii});
        writeEval=[writeEval,', vars{',num2str(ii),'}'];
        r=[r,'$Load ',vars{ii}.name,'=',vars{ii}.name,char(13,10)'];
    end
end

writeEval=[writeEval,');'];
eval(writeEval);
r=[r,'$GDXIN',char(13,10)',';'];
end