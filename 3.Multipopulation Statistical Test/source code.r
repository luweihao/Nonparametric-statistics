#Reference: Wang. J. L., Non-parametric statistical analysis,2006.4

### Kruskal-Wallis One-way ANOVA
##  page 92
## When number of groups k=2, equivalent to Wilcoxon-Mann-Whitney U test
medicine=c(80,203,235,252,284,368,457,393,
           133,180,100,160,
           156,295,320,448,465,481,279,
           194,214,272,330,386,475)
group=rep(1:4, c(8,4,7,6))
kruskal.test(medicine, group)



### Trend-Rank-Test
##  page 99
trendrank.test=function(x, group, fixed.knot=TRUE){
    rankx=rank(x)
    
    k=length(unique(group))
    N=length(group)
    
    Rimean=rep(0, k)
    wi=rep(0, k+1)
    ni=rep(0, k+1)
    for(i in 1:k){
        Rimean[i]=sum(rankx[group==i])
        ni[i+1]=sum(group==i)
        wi[i+1]=wi[i]+ni[i+1]+ni[i]
    }
    wi=wi[-1]
    ni=ni[-1]
    T.stat=sum(Rimean*wi)
    ET.H0=N^2*(N+1)/2
    if(!fixed.knot){
        DT.H0=N*(N+1)*(sum(ni*wi^2)-N^3)/12 
    }else{
        knot=as.numeric(table(rankx[duplicated(rankx)])+1)
        DT.H0=(N*(N^2-1)-sum(knot^3-knot))*(sum(ni*wi^2)-N^3)/(12*(N-1))
    }
    p.value=pnorm((T.stat-ET.H0)/sqrt(DT.H0), lower.tail = F)
    names(T.stat) <- "Trend-Rank-Test statistics"
    RVAL <- list(statistic=T.stat, p.value=p.value, method="Trend-Rank-Test",
                 data.name=deparse(substitute(x)))
    class(RVAL) <- "htest"
    return(RVAL)
}

Beta.lipoprotein=c(260,200,240,170,270,205,190,200,250,200,
                   310,310,190,225,170,210,280,210,280,240,
                   320,260,360,310,270,380,240,295,260,250)
group=gl(3,10)
trendrank.test(Beta.lipoprotein, group)
trendrank.test(Beta.lipoprotein, group, fixed.knot = FALSE)



### Jonckheere Terpstra Test
##  page 101
## When number of groups k=2, equivalent to Wilcoxon-Mann-Whitney U test
## The following code is modified by trendrank.test()
jonckheere.test=function(x, group, fixed.knot=TRUE){
    rankx=rank(x)
    
    k=length(unique(group))
    N=length(group)
    
    ni=rep(0, k)
    J.stat=0
    for(m in 1:k){
        ni[m]=sum(group==m)
    }
    csum.ni=c(0,cumsum(ni))
    for(j in 2:k){
        for(i in 1:(j-1)){
            J.stat=J.stat+sum(
                sapply(x[(csum.ni[i]+1):csum.ni[i+1]],
                       "<",
                       x[(csum.ni[j]+1):csum.ni[j+1]]))
        }
    }
    EJ.H0=(N^2-sum(ni^2))/4
    if(!fixed.knot){
        DJ.H0=(N^2*(2*N+3)-2*sum(ni^3)-3*sum(ni^2))/72
    }else{
        knot=as.numeric(table(rankx[duplicated(rankx)])+1)
        DJ.H0=(N^2*(2*N+3)-2*sum(ni^3)-3*sum(ni^2)-sum(knot*(knot-1)*(2*knot+5)))/72+
              sum(ni*(ni-1)*(ni-2))*sum(knot*(knot-1)*(knot-2))/(36*N*(N-1)*(N-2))+
              sum(ni*(ni-1))*sum(knot*(knot-1))/(8*N*(N-1))
    }
    p.value=pnorm((J.stat-EJ.H0)/sqrt(DJ.H0), lower.tail = F)
    names(J.stat) <- "Jonckheere-Terpstra-Test statistics"
    RVAL <- list(statistic=J.stat, p.value=p.value, method="Jonckheere-Terpstra-Test",
                 data.name=deparse(substitute(x)))
    class(RVAL) <- "htest"
    return(RVAL)
}

heartbeat=c(125,136,116,101,105,109,
            122,114,131,120,119,127,
            128,142,128,134,135,131,140,129)
group=rep(1:3, c(6,6,8))
jonckheere.test(heartbeat, group)
jonckheere.test(heartbeat, group, fixed.knot = FALSE)
