function r= writeToGDX(filename,param)
%�������Զ�д��GDX�ļ�
%
%���ߣ�ʷ��Բ @ ��������ѧ
%���䣺shishouyuan@outlook.com
%
%�޸�ʱ�䣺2018-6-6
%�����˽ṹ�������ʽ
%�����˲������к��»��߲�����ʶ������������
%����ʱ�䣺2018-6-5
%
%����˵����
%filename:Ҫд���GDX�ļ���
%param��
%��ʽһ������ǰ׺��������ʶҪд��ı���
%��ʽ������������Ҫд��ı����Ľṹ��
%
%����ֵ��GAMS���ڵ������������磺
% $GDXIN C:\Users\Shouyuan\Desktop\abc.gdx
% $Load Power=Power
% $Load Power2=Power2
% $GDXIN
% ;
%
%ʹ�÷�����
%��ʽһ��
%��Ҫд��GDX�ı�����������ĸ�ʽ���������ô˺����ṩfilename����ΪҪд���GDX�ļ�·������
%������ʽ
%param_ά��_GDX�еĲ�����
%���ӣ�
% prefix='GDX';
% GDX_2_Power=[1,2;3,4];
% GDX_2_Power2=[1,2;3,4];
% writeToGDX('C:\Users\Shouyuan\Desktop\abc.gdx',prefix)
%��ʽ����
%��Ҫд��GDX�ı�������һ���ṹ���У��ṹ��������ĸ�ʽ���������ô˺����ṩfilename����ΪҪд���GDX�ļ�·������
%�ṹ�����ʽ
%GDX�еĲ�����_ά��
%���ӣ�
%p.Power1_0=1;
%p.Power2_2=[1,2;3,4];
%writeToGDX('C:\Users\Shouyuan\Desktop\abc.gdx',p)

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