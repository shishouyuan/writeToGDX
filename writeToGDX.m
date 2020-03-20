function r= writeToGDX(filename,param)
%将变量自动写入GDX文件
%
%作者：史守圆 @ 华南理工大学
%邮箱：shishouyuan@outlook.com
%
%修改时间：2018-6-6
%增加了结构体输入格式
%修正了参数名中含下划线参数名识别不完整的问题
%初版时间：2018-6-5
%
%参数说明：
%filename:要写入的GDX文件名
%param：
%格式一：变量前缀，用来标识要写入的变量
%格式二：包含所有要写入的变量的结构体
%
%返回值：GAMS用于导入参数的命令，如：
% $GDXIN C:\Users\Shouyuan\Desktop\abc.gdx
% $Load Power=Power
% $Load Power2=Power2
% $GDXIN
% ;
%
%使用方法：
%格式一：
%将要写入GDX的变量均以下面的格式命名，调用此函数提供filename参数为要写入的GDX文件路径即可
%变量格式
%param_维数_GDX中的参数名
%例子：
% prefix='GDX';
% GDX_2_Power=[1,2;3,4];
% GDX_2_Power2=[1,2;3,4];
% writeToGDX('C:\Users\Shouyuan\Desktop\abc.gdx',prefix)
%格式二：
%将要写入GDX的变量放入一个结构体中，结构体域按下面的格式命名，调用此函数提供filename参数为要写入的GDX文件路径即可
%结构体域格式
%GDX中的参数名_维数
%例子：
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