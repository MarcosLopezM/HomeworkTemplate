%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%                                                    %%
%%                 fc-hw-template.cls                 %%
%%                                                    %%
%% ================================================== %%
%%                                                    %%
%% Version:     2.6 (2025/06/17)                      %%
%% Author:      Marcos López Merino                   %%
%% License:     MIT LICENSE                           %%
%% GitHub Repo: http://tinyurl.com/hw-template        %%
%% Compiler:    lualatex                              %%
%%                                                    %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{fc-hw-template}[2025/06/17 Facultad de Ciencias Assignment Template]

\RequirePackage{ifthen}
\RequirePackage{xkeyval}

%% Colors
\RequirePackage[dvipsnames]{xcolor}
\definecolor{base3}{RGB}{253, 246, 227}%
\definecolor{pinkwave}{RGB}{255, 0, 128}%
\definecolor{customBlue}{RGB}{11, 61, 98}%

%% Class and Options
\def\@@ptsize{10pt} % Default font size
\DeclareOption{9pt}{\def\@@ptsize{9pt}}
\DeclareOption{10pt}{\def\@@ptsize{10pt}}
\DeclareOption{11pt}{\def\@@ptsize{11pt}}
\DeclareOption{12pt}{\def\@@ptsize{12pt}}
\ProcessOptions\relax
% Define default options
\newif\ifdigital\digitalfalse
\DeclareOptionX{digital}[true]{\ifthenelse{\equal{#1}{true}}{\digitaltrue}{\digitalfalse}}

\ProcessOptionsX
\LoadClass[twoside, letterpaper,\@@ptsize]{article}

% Define custom macros for changing page color and other actions
\newcommand{\SetDigitalMode}{%
	\ifdigital
		\pagecolor{base3}
	\fi
}

% Execute custom actions based on options after the document class is loaded
\AtBeginDocument{\SetDigitalMode}

%% Page Settings
\RequirePackage[twoside, inner=2.0cm,outer=2.0cm,top=1.2cm,bottom=3.5cm]{geometry}
\newcommand{\firstfooteradditionalheight}{2em} % additional height for footer on the first page
\hfuzz=.5em % disable false positive of overfull \hbox

%% LuaLaTeX Specific Package
\RequirePackage{linebreaker} % line-breaker algorithm in LuaLaTeX

%% Multiple Packages with same name commands
\RequirePackage{savesym} % Renames commands for conflicted packages

%% Fonts
\RequirePackage{fontspec}
\newfontfamily\linuxlibertine[%
	% Path = /usr/local/texlive/texmf-local/tex/latex/fc-hw-template/fonts/linux-libertine/,
	Path = ./fonts/linux-libertine/,
	Extension = .otf,
	UprightFont = *_R,
	BoldFont = *_RB,
	BoldItalicFont = *_RBI,
	ItalicFont = *_RI,
	Ligatures = {
			TeX,
		}
]{LinLibertine}

\newfontfamily\linuxbiolinum[%
	% Path = /usr/local/texlive/texmf-local/tex/latex/fc-hw-template/fonts/linux-biolinum/,
	Path = ./fonts/linux-biolinum/,
	Extension = .otf,
	UprightFont = *_R,
	BoldFont = *_RB,
	ItalicFont = *_RI,
	Ligatures = {
			TeX,
		}
]{LinBiolinum}

% Line-breaker Settings
\linebreakersetup {
	maxtolerance = 90,
	maxemergencystretch = 1em,
	maxcycles = 4
}

%% Language Settings
\RequirePackage[english, spanish, es-nodecimaldot]{babel}
\RequirePackage{csquotes}
\RequirePackage[es]{datetime2}

%% Document Properties
\global\let\@assignno\@empty
\global\let\@group\@empty
\global\let\@semester\@empty
\global\let\@instructor\@empty
\global\let\@duedate\@empty
\global\let\@author\@empty
\global\let\@subject\@empty
\newcommand{\assignno}[1]{\gdef\@assignno{#1}} % Assignment Number
\newcommand{\group}[1]{\gdef\@group{#1}} % Group
\newcommand{\semester}[1]{\gdef\@semester{#1}} % Semester
\newcommand{\instructor}[1]{\gdef\@instructor{#1}} % Instructor
\newcommand{\duedate}[1]{\gdef\@duedate{#1}} % Due Date of the Assignment
\newcommand{\subject}[1]{\gdef\@subject{#1}} % Subject

\setlength{\parindent}{0pt} % Indentation
\setlength{\parskip}{0.5em} % Space in between paragraphs
\linespread{1.1} % Line spacing

%% Graphics Settings
\RequirePackage{graphicx} % Inclusion of graphics
\RequirePackage[export]{adjustbox} % Extends the “key=value” interface of \includegraphics 
\graphicspath{{img/}}

%% List Settings
\RequirePackage[inline]{enumitem}
\RequirePackage{multicol}
\setlist[enumerate, 1] {
	label = (\alph*),
}

% Multicol environment for lists
\SetEnumitemKey{twocol}{
	itemsep = 1\itemsep,
	parsep = 0.5\parsep,
	before = \raggedcolumns\begin{multicols}{2},
		after = \end{multicols}}

\SetEnumitemKey{threecol}{
	itemsep = 1\itemsep,
	parsep = 0.5\parsep,
	before = \raggedcolumns\begin{multicols}{3},
		after = \end{multicols}}

%% TikZ Rule
\RequirePackage{tikz}
\usetikzlibrary{fadings, calc}
\newcommand{\tikzrule}[3][]{\tikz{\fill[#1] (0,0) rectangle (#2,#3);}}

%% Sections Settings
\RequirePackage[explicit]{titlesec} % explained in https://tex.stackexchange.com/a/292307/234654
\RequirePackage{suffix}

\newcommand{\sectionheadname}{Problema} % Name for the Section (default as 'Problema')

\global\let\@problempts\@empty
\newcommand{\problempts}[1]{\gdef\@problempts{#1}} % Points of the Problem
\newcommand{\problemptsprint}{\ifx\@problempts\@empty\else(\@problempts~pts)\fi}

% Counter for Problema
\newcounter{problema}

% Problema environment
\NewDocumentEnvironment{problema}{O{} O{}}% [optional points] [optional title]
{%
	\refstepcounter{problema}%
	\problempts{#1}%
	\def\problematitle{#2}%

	\let\problema@oldequation\theequation
	\numberwithin{equation}{problema} % equation counter depends on problema
	\renewcommand{\theequation}{\theproblema.\arabic{equation}}

	% Texto que se muestra
	\def\problemaheadertext{%
		\sectionheadname~\theproblema%
		\ifx\problematitle\@empty
			% no título
		\else
			: \problematitle%
		\fi
	}%

	% Header visual
	\noindent
	\begin{minipage}[t]{\textwidth}
		{\Large\bfseries\problemaheadertext}%
		\hfill
		{\Large\bfseries\problemptsprint}%
	\end{minipage}
	\par\vspace{1em}

	% Add to TOC
	\addcontentsline{toc}{section}{\problemaheadertext}
}
{%
	\renewcommand{\theequation}{\problema@oldequation}
}

% Optional: force the number of the problem manually (if needed)
\newcommand{\setproblem}[1]{\ifx#1\@empty\else\setcounter{problema}{#1}\fi}

% Spacing for sections
\titlespacing*{\section}{0em}{2.5\baselineskip}{1\baselineskip}

%% Maths Settings
\RequirePackage{mathtools}
\RequirePackage{amsfonts}
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{bm} % \bm command
\RequirePackage{derivative}
\RequirePackage{empheq} % Boxes around equations
\RequirePackage{linop} % Lineal Operators for QM
\RequirePackage{lualatex-math}
\RequirePackage{mismath}
\savesymbol{tr}
\savesymbol{rank}
\RequirePackage{nicematrix} % Better matrix handling
\RequirePackage{simples-matrices} % Fast matrix typing
\numberwithin{equation}{section}

\setlength{\jot}{10pt} % Space between lines in multiline eqs
\allowdisplaybreaks % Allow page breaks in multiline equations

% Unit vectors
\newcommand*{\uveci}{{\bm{\hat{\textnormal{\bfseries\i}}}}}
% unit vector j
\newcommand*{\uvecj}{{\bm{\hat{\textnormal{\bfseries\j}}}}}
% unit vector k
\newcommand*{\uveck}{{\bm{\hat{\textnormal{\bfseries k}}}}}
% unit vector
\DeclareRobustCommand{\uvec}[1]{{%
			\ifcsname uvec#1\endcsname
				\csname uvec#1\endcsname
			\else
				\bm{\hat{#1}}%
			\fi
		}}% 

%% Empheq Settings
% Defining a variant of Aboxed command from mathtools
\newcommand\mainresult[1]{\color{pinkwave}\fboxsep=3.5pt\fboxrule=1.2pt\fbox{\color{black}#1}}
\MakeAboxedCommand\Aboxedmain\mainresult
\newcommand*\widefbox[1]{\fboxsep=3.5pt\fboxrule=1.5pt\fbox{#1}}

\newcommand\secondaryresult[1]{\color{customBlue}\fboxsep=3.5pt\fbox{\color{black}#1}}
\MakeAboxedCommand\Aboxedsec\secondaryresult

% Custom boxes for results with background color specified by class option
% Box for main result
\newcommand*\resultbox[1]{%
	\setlength\fboxrule{1.5pt}%
	\ifdigital
		\fcolorbox{pinkwave}{base3}{\hspace{1em}#1\hspace{1em}}%
	\else
		\fcolorbox{pinkwave}{white}{\hspace{1em}#1\hspace{1em}}%
	\fi
}

% Box for relevant result
\newcommand*\secbox[1]{%
	\setlength\fboxrule{1pt}%
	\ifdigital
		\fcolorbox{customBlue}{base3}{\hspace{1em}#1\hspace{1em}}%
	\else
		\fcolorbox{customBlue}{white}{\hspace{1em}#1\hspace{1em}}%
	\fi
}

%% Physics Settings
\RequirePackage{phfqit} % Necessary commands for quantum mechanics
\savesymbol{so}
\RequirePackage{siunitx}

% SIUnitX Settings
\sisetup{
	output-decimal-marker = {.},
	separate-uncertainty = false,
	exponent-product = \mul,
	inter-unit-product = \ensuremath{{}\cdot{}}
}

%% Dummy Text Settings
\RequirePackage{kantlipsum}

%% Subfiles Management Settings
\RequirePackage{subfiles}

%% Bookmarks Settings
\RequirePackage[numbered]{bookmark}
\RequirePackage{letltxmacro}

%% Captions Settings
\RequirePackage[font=footnotesize,labelfont=bf]{caption}

%% Footnote Settings
\RequirePackage[bottom]{footmisc} % glue footnote to bottom
\renewcommand{\footnoterule}{\noindent\tikzrule[SeaGreen, path fading=east]{.4\textwidth}{.1em}}
\renewcommand{\footnotesep}{1em}

%% Header and Footer
\RequirePackage{fancyhdr}
\RequirePackage{pageslts}
\pagenumbering{arabic}
\RequirePackage{hyperref}
\RequirePackage{zref-clever}
\RequirePackage{zref-user}

\zcsetup{
	lang = spanish ,
	cap = false ,
	capfirst = true ,
	hyperref = auto ,
}

\hypersetup{
	colorlinks = true,%
	linkcolor={[rgb]{0,0.2,0.6}},%
	citecolor={[rgb]{0,0.6,0.2}},%
	filecolor={[rgb]{0.8,0,0.8}},%
	urlcolor={[rgb]{0.8,0,0.8}},%
	runcolor={[rgb]{0.8,0,0.8}},% 
	menucolor={[rgb]{0,0.2,0.6}},%
	linkbordercolor={[rgb]{0,0.2,0.6}},%
	citebordercolor={[rgb]{0,0.6,0.2}},%
	filebordercolor={[rgb]{0.8,0,0.8}},%
	urlbordercolor={[rgb]{0.8,0,0.8}},%
	runbordercolor={[rgb]{0.8,0,0.8}},%
	menubordercolor={[rgb]{0,0.2,0.6}},% 
	unicode=true,%
}

\newcommand{\startsolution}{%
	% Cambio de fuente y estilo
	{\linuxlibertine\centering\LARGE\scshape
			\vspace{\baselineskip}%

			Solución\\[-0.2em]%

			% Línea horizontal decorativa
			\tikzrule[pinkwave, path fading=west]{.5\textwidth}{.2em}%
			\tikzrule[pinkwave, path fading=east]{.5\textwidth}{.2em}%

			\par\vspace{1em}%
		}%
	\noindent
}
\setlength{\headheight}{52pt}
\setlength{\marginparwidth}{2cm}
\pagestyle{fancy}

\fancyhf{} % Limpiar cabeceras y pies de página

% Definir la línea de la cabecera, alternando según paridad de página
\renewcommand\headrule{%
	\ifodd\thepage
		\vspace{-0.7em}%
		\tikzrule[pinkwave, path fading=east]{.5\textwidth}{0.3mm}%
	\else
		\vspace{-0.7em}%
		\hfill\tikzrule[pinkwave, path fading=west]{.5\textwidth}{0.3mm}%
	\fi
}

% Definir texto común que aparece en LO y RE
\newcommand{\myHeaderText}{%
	\linuxlibertine
	\textsc{\@subject~---~\@title~\@assignno}%
}

% Asignar cabeceras
\fancyhead[LO]{\myHeaderText}
\fancyhead[RE]{\myHeaderText}

% Número de página en LE y RO
\fancyhead[LE,RO]{Pág. \thepage{} \hspace{1pt} de \lastpageref{pagesLTS.arabic}}
\cfoot{}
% header and footer style for the first page
\fancypagestyle{firstpage}{
	\renewcommand\headrule{}
	\lhead{}
	\rhead{}
	\cfoot{
		\includegraphics[scale = 0.2, valign = c]{LogoFCUNAMcolor.pdf}
	}
}

%% Title Settings
\RequirePackage{afterpage}
\newcommand{\setduedate}[1]{\DTMDate{#1}}
\makeatletter
\renewcommand\maketitle{
	\thispagestyle{firstpage}
	\linuxlibertine
	\enlargethispage{-\firstfooteradditionalheight} % make room for the footer
	\begin{minipage}{10.5cm}
		\centering
		{
			% \fontsize{36}{48}\selectfont
			\fontsize{30}{62}\selectfont
			\textcolor{Plum}{\scshape \@subject}
		}\\[.5em]
		{
		\@author
		\qquad
		\textit{Prof.:~\@instructor}
		}
	\end{minipage}
	\begin{minipage}{5cm}
		\vspace{0.7em}
		\centering
		{
			\large
			\linuxbiolinum
			\textcolor{BrickRed}{Grupo~\@group~-- \@semester}
		}\\[.5em]
		{
		\ifx\@assignno\@empty
			\vspace{2mm}
			\LARGE\@title
		\else
			\vspace{2mm}
			\LARGE\@title~{\@assignno}
		\fi
		}
	\end{minipage}
	\\[.3em]
	\color{customBlue} \hrule width \hsize height 2pt \kern 1mm \hrule width \hsize
	\color{black} % Reset color after rules
	% Due date
	\ifx\@duedate\@empty
		\begin{center}
			\textbf{\normalsize Entrega:~\DTMtoday}
		\end{center}
	\else
		\begin{center}
			\textbf{\normalsize Entrega:~\setduedate{\@duedate}}
		\end{center}
	\fi

	% Set up document meta data
	% Note that it should be placed here because
	% by now \@author and \@title have been set.
	\hypersetup{
		pdfauthor={\@author},
		pdftitle={%
				\@title~\@assignno~
				- \@subject%
			},
		pdfsubject={\@subject},
		pdfkeywords={%
				\@title%
				\ifx\@subject\@empty\else%
					, \@subject%
				\fi%
			},
		pdfcreator={LaTeX with fc-hw-template class},
		pdfproducer={LaTeX, LuaLaTeX}
	}
}
\makeatother
