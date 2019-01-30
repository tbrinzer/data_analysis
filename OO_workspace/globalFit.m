<<<<<<< HEAD
function [pfit,err,gfOpts] = globalFit(dataMatrix,w1,w3,p_array,gfOpts,lb,ub)
% [x,xError,struct] = globalFit(dataMat,w1,w3,p0,gfOptions

% Scale intensity of the calculated Response Function to match that of the
% 2D-IR spectrum. This also adds some natural weighting (by the signal size
% of each spectrum) of the fit.
scale = gfScale(dataMatrix);

% The variable MAXSCALE allows us to renormalize the data, so that we aren't constantly
% exceeding our tolerance because of the large amplitudes of our spectra.
maxScale = abs(min(min(min(dataMatrix))));

err_fun = @(p,gfOpts) sum(sum(sum((dataMatrix-analyticalResponseFunctionsFun(p,w1,w3,gfOpts).*scale).^2)))./maxScale;

%tolfun relates to the squared residual in the error
%tolx relates to the displacement in your parameters
tolfun = 1e-17;
tolx = 1e-10;
maxfun = 1e3; %maximum number of function evaluations


% set fit parameters (versions of MatLab before 2013a did not have the OPTIMOPTIONS function)
if exist('optimoptions')==2,
    opt = optimoptions('fmincon','Algorithm','active-set','Display','iter','TolFun',tolfun,'TolX',tolx,'MaxFunEvals',maxfun);
elseif exist('optimset')==2,
%    opt = optimset('Algorithm','active-set','Display','iter','TolFun',tolfun,'TolX',tolx,'MaxFunEvals',maxfun);
    opt = optimset('Algorithm','active-set','Display','iter','TolFun',tolfun,'TolX',tolx,'MaxFunEvals',maxfun);
else
    warning('Could not set parameters! Look for the right options functon for your installation.');
end


tic

% fmincon has required parameters of error function and initial guess. We
% are omitting any linear inequalities that we could subject the minimizer
% to (e.g. we could include A and b (input parameters 3 & 4), and would
% require that A*pfit <= b.
[pfit,err] = fmincon(err_fun,p_array,[],[],[],[],lb,ub,[],opt,gfOpts)

toc

gfOpts.pfit = pfit;
gfOpts.fitMethod = 'unweighted fit';

for ii = 1:length(pfit)
    fprintf(1,'%20s\t%12f\n',gfOpts.pnames{ii},pfit(ii));
=======
function [pfit,err,gfstruct] = globalFit(dataMatrix,w1,w3,p_array,gfstruct,lb,ub)

% Rather than changing our data matrix intensity, we now scale our response
% function calculation to it.
scale = gfScale(dataMatrix);

% MAXSCALE allows us to renormalize the data, so that we aren't constantly
% exceeding our tolerance because of the large size of our response.
maxScale = abs(min(min(min(dataMatrix))));
err_fun = @(p,gfstruct) sum(sum(sum((dataMatrix-analyticalResponseFunctionsFun(p,w1,w3,gfstruct).*scale).^2)))./maxScale;

%tolfun relates to the squared residual in the error
%tolx relates to the displacement in your parameters
tolfun = 1e-17;
tolx = 1e-10;
maxfun = 1e3; %maximum number of function evaluations


% set fit parameters (I believe based on version of matlab)
if exist('optimoptions')==2,
    opt = optimoptions('fmincon','Algorithm','active-set','Display','iter','TolFun',tolfun,'TolX',tolx,'MaxFunEvals',maxfun);
elseif exist('optimset')==2,
%    opt = optimset('Algorithm','active-set','Display','iter','TolFun',tolfun,'TolX',tolx,'MaxFunEvals',maxfun);
    opt = optimset('Algorithm','active-set','Display','iter','TolFun',tolfun,'TolX',tolx,'MaxFunEvals',maxfun);
else
    warning('Could not set parameters! Look for the right options functon for your installation.');
end


tic

%fmincon has required parameters of error function and initial guess.
%Documentation has a bunch of additional parameters, most of which we don't
%understand, but the syntax for not using them is to leave them as blanks.
[pfit,err] = fmincon(err_fun,p_array,[],[],[],[],lb,ub,[],opt,gfstruct)

toc

gfstruct.pfit = pfit;
gfstruct.fitMethod = 'unweighted fit';

for ii = 1:length(pfit)
    fprintf(1,'%20s\t%12f\n',gfstruct.pnames{ii},pfit(ii));
>>>>>>> 7b4ffa1e907efec2c83096a8c539235b46d1e69a
end