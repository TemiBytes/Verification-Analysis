-- Index for confidence-related filters
CREATE INDEX idx_confidence ON verifications (confidence);

-- Index for duplicate check
CREATE INDEX idx_duplicate_check ON verifications (duplicate_check);

-- Index for manual review triggers
CREATE INDEX idx_review_id ON verifications (reason_for_human_review_id);

-- Optional: Composite index for combined use cases
CREATE INDEX idx_composite_check ON verifications (confidence, duplicate_check, reason_for_human_review_id);
