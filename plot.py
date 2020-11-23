#!/usr/bin/env python3
import matplotlib
matplotlib.use('Agg')

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.ticker as mtick
from matplotlib import rc
import pandas as pd
import json
import os

# Data
def save_fig10(isgoker):
    src = './result/fig10.goker.json'
    dst = './cmd/pdf/fig10.goker.png'
    title = '(b) GoKer'
    if not isgoker:
        src = './result/fig10.goreal.json'
        dst = './cmd/pdf/fig10.goreal.png'
        title = '(a) GoReal'
    if not os.path.exists(src):
        return
    with open(src) as fp:
        raw_data = json.load(fp)

    df = pd.DataFrame(raw_data)

    # From raw value to percentage
    xnames = ['goleak', 'go-deadlock', 'Go-rd']
    ynames = ['(0, 1]', '(1, 100]', '(100, 1000]', '(1000, +]']
    totals = [i+j+k+m for i,j,k,m in zip(df['(0, 1]'], df['(1, 100]'], df['(100, 1000]'], df['(1000, +]'])]

    bars = []
    for k in range(len(ynames)):
        data = df[ynames[k]]
        bar = []
        for i in range(len(data)):
            if data[i] == 0:
                bar.append(0)
            else:
                bar.append(data[i]/totals[i]*100)
        bars.append(bar)

    bars = list(reversed(bars))
    # plot
    r = [0,1,2]
    barWidth = 0.5

    plt.bar(r, bars[0], color='black', width=barWidth)
    plt.bar(r, bars[1], bottom=bars[0], color='dimgrey', width=barWidth)
    plt.bar(r, bars[2], bottom=[i+j for i,j in zip(bars[0], bars[1])], color='darkgrey', width=barWidth)
    plt.bar(r, bars[3], bottom=[i+j+k for i,j,k in zip(bars[0], bars[1], bars[2])], color='lightgrey', width=barWidth)

    # Custom x axis
    plt.xticks(r, ['$\it{}$'.format(n) for n in xnames])
    ax = plt.gca()
    # ax.yaxis.set_major_formatter(mtick.PercentFormatter())
    ticks_loc = ax.get_yticks().tolist()
    ax.yaxis.set_major_locator(mtick.FixedLocator(ticks_loc))
    ax.set_yticklabels(['{:.0f}%'.format(y) for y in ticks_loc])

    #ax.set_yticklabels(['{:.0f}%'.format(y) for y in ax.get_yticks()], fontsize=15)

    plt.gca().get_yticks()
    plt.xlabel(title)
    plt.legend(ncol=len(ynames), labels=ynames[::-1], bbox_to_anchor=(-0.1, 1.15), loc='upper left', frameon=False)
    ax.yaxis.grid(True, linestyle='--')
    ax.set_axisbelow(True)
    # Store graphic
    plt.savefig(dst)

save_fig10(True)
save_fig10(False)
