#include <MBLisp/Evaluator.h>
#include <MBLisp/Modules/CLI/CLI.h>

#include <iostream>
int main(int argc, const char** argv)
{
    std::shared_ptr<MBLisp::Evaluator> Evaluator = MBLisp::Evaluator::CreateEvaluator();
    try
    {
        if(argc == 1)
        {
            Evaluator->Repl();
        }
        std::string FileContent = argv[1];
        Evaluator->LoadStd();
        auto Scope = Evaluator->Eval("C:/Users/emanu/Desktop/Program/C++/MBTML/TML/TML.lisp");
        auto TestClass = Evaluator->GetValue(*Scope,"TestClass");
        MBLisp::LispWindow Window = MBLisp::LispWindow(Evaluator, Evaluator->Eval(Scope,TestClass,{MBLisp::Dict(),MBLisp::List()}));
        MBCLI::MBTerminal Terminal;
        Terminal.Clear();
        Terminal.WriteWindow(Window);
        while(true)
        {
            auto Input = Terminal.ReadNextInput();
            Window.HandleInput(Input);
            Terminal.WriteWindow(Window);
        }
    }
    catch(MBLisp::LookupError const& e)
    {
        std::cout<<e.what()<<": "<<Evaluator->GetSymbolString(e.GetSymbol())<<std::endl;
    }
    catch (MBLisp::UncaughtSignal& e)
    {
        std::cout<<"Uncaught signal:";
        Evaluator->Eval(e.AssociatedScope, e.AssociatedScope->FindVariable(Evaluator->GetSymbolID("print")), {e.ThrownValue});
    }
    catch(std::exception const& e)
    {
        std::cout<<e.what()<<std::endl;
    }
}
