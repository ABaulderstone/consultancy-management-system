import type { RevenueShare } from '../types/analytics';

function normalize(shares: RevenueShare[]): RevenueShare[] {
	const total = shares.reduce((sum, s) => sum + s.share, 0);

	const normalized = shares.map((s) => ({
		...s,
		share: (s.share / total) * 100
	}));

	// fix rounding drift
	const diff = 100 - normalized.reduce((sum, s) => sum + s.share, 0);
	if (normalized.length > 0) {
		normalized[normalized.length - 1].share += diff;
	}

	return normalized.map((s) => ({
		...s,
		share: Number(s.share.toFixed(2))
	}));
}

export function mockBalanced(): RevenueShare[] {
	return normalize([
		{ clientName: 'Client A', share: 25 },
		{ clientName: 'Client B', share: 25 },
		{ clientName: 'Client C', share: 25 },
		{ clientName: 'Client D', share: 25 }
	]);
}

export function mockConcentrated(): RevenueShare[] {
	return normalize([
		{ clientName: 'BigCorp', share: 70 },
		{ clientName: 'StartupX', share: 15 },
		{ clientName: 'SmallCo', share: 10 },
		{ clientName: 'TinyCo', share: 5 }
	]);
}

export function mockSingleClient(): RevenueShare[] {
	return [{ clientName: 'OnlyClient', share: 100 }];
}

export function mockManySmall(): RevenueShare[] {
	return normalize(
		Array.from({ length: 10 }, (_, i) => ({
			clientName: `Client ${i + 1}`,
			share: 5 + Math.random() * 5
		}))
	);
}

export function mockWithOther(): RevenueShare[] {
	return [
		{ clientName: 'BigCorp', share: 60 },
		{ clientName: 'StartupX', share: 25 },
		{ clientName: 'Other', share: 15 }
	];
}

export function mockEmpty(): RevenueShare[] {
	return [];
}
