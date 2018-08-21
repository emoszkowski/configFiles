% Page formatting
\LoadClass{beamer}
% \usetheme{Boadilla}
\usetheme{metropolis}

% Section title slide
% http://tex.stackexchange.com/a/178803
% \AtBeginSection[]{
%   \begin{frame}
%     \vfill
%     \centering
%     \begin{beamercolorbox}[sep=8pt,center,shadow=true,rounded=true]{title}
%       \usebeamerfont{title}\insertsectionhead\par%
%     \end{beamercolorbox}
%     \vfill
%   \end{frame}
% }

% Section title slide
\AtBeginSection[]
{
 \begin{frame}<beamer>
 \frametitle{Outline}
 \tableofcontents[currentsection]
 \end{frame}
}

% Load mystyle.sty
% \usepackage{mystyle}
% \usepackage{mybeamerstyle}
