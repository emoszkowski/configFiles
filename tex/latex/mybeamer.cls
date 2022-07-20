% Page formatting
\ProvidesClass{beamer16x9}
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{beamer}}
\ProcessOptions\relax
\LoadClass[aspectratio=169]{beamer}

% \usetheme{Boadilla}
\usetheme[block=fill]{metropolis}

% Load beamer style
\usepackage{mybeamerstyle}


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

% Make default font size bigger
% \setbeamerfont{normal text}{size*{16}{18}}
% \AtBeginDocument{
%  \usebeamerfont{normal text}
% }

% Section title slide
\AtBeginSection[]
{
 \begin{frame}<beamer>
 \frametitle{Outline}
 \tableofcontents[currentsection]
 \end{frame}
}

% Footer
\makeatother
\setbeamertemplate{footline}
{
  \leavevmode%
  \hbox{%
  \begin{beamercolorbox}[wd=.3\paperwidth,ht=2.25ex,dp=1ex,center]{author in head/foot}%
    \usebeamerfont{author in head/foot}\insertshortauthor
  \end{beamercolorbox}%
  \begin{beamercolorbox}[wd=.6\paperwidth,ht=2.25ex,dp=1ex,center]{title in head/foot}%
    \usebeamerfont{title in head/foot}\insertshorttitle\hspace*{3em}
    % \insertframenumber{} / \inserttotalframenumber\hspace*{1ex}
  \end{beamercolorbox}%
  \begin{beamercolorbox}[wd=.1\paperwidth,ht=2.25ex,dp=1ex,center]{date in head/foot}%
    \insertframenumber{} / \inserttotalframenumber\hspace*{1ex}
  \end{beamercolorbox}}%
  \vskip0pt%
}
\makeatletter
